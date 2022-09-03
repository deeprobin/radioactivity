using RadioactivityApp.Bfs;
using RadioactivityApp.BfsClient.Models;
using RadioactivityApp.Infrastructure.Data;
using System.Diagnostics;
using System.Runtime.CompilerServices;

namespace RadioactivityApp.Measurements;

public sealed class MeasurementService : IMeasurementService
{
    private readonly IServiceProvider _serviceProvider;
    private readonly IBfsService _bfsService;
    private readonly ILogger<MeasurementService> _logger;

    private readonly IDictionary<string, DateTime> _lastBfsFetch = new Dictionary<string, DateTime>();

    public MeasurementService(IBfsService bfsService, ILogger<MeasurementService> logger, IServiceProvider serviceProvider)
    {
        _bfsService = bfsService;
        _logger = logger;
        _serviceProvider = serviceProvider;
    }

    private async IAsyncEnumerable<Measurement> CollectMeasurements24HourAsync(string kenn, [EnumeratorCancellation] CancellationToken cancellationToken)
    {
        var odlLatest1Hour = await _bfsService.GetOdlTimeseries24Hour(kenn, cancellationToken);
        if (odlLatest1Hour.Features is null)
        {
            _logger.LogError("BFS API returned no features (corrupted JSON)");
            yield break;
        }
        foreach (var feature in odlLatest1Hour.Features)
        {
            if (feature.Properties is null)
            {
                _logger.LogError("BFS API returned no properties (corrupted JSON)");
                continue;
            }

            if (feature.Properties.Value is null)
            {
                _logger.LogError("BFS API returned no value (corrupted JSON)");
                continue;
            }

            var extendedProperties = feature.Properties as ExtendedFeatureProperties;
            if (feature.Properties.StartMeasure is not null)
            {
                yield return new Measurement
                {
                    Kenn = kenn,
                    Id = feature.Properties.Id,
                    Timestamp = feature.Properties.StartMeasure.Value,
                    Nuclide = feature.Properties.Nuclide,
                    Unit = feature.Properties.Unit,
                    Validated = feature.Properties.Validated == 2,
                    Value = (double)feature.Properties.Value.Value,
                    ValueCosmic = extendedProperties?.ValueCosmic.HasValue == true ? (double)extendedProperties.ValueCosmic.Value : default,
                    ValueTerrestrial = extendedProperties?.ValueTerrestrial.HasValue == true ? (double)extendedProperties.ValueTerrestrial.Value : default,
                };
            }
            if (feature.Properties.EndMeasure is not null)
            {
                yield return new Measurement
                {
                    Kenn = kenn,
                    Id = feature.Properties.Id,
                    Timestamp = feature.Properties.EndMeasure.Value,
                    Nuclide = feature.Properties.Nuclide,
                    Unit = feature.Properties.Unit,
                    Validated = feature.Properties.Validated == 2,
                    Value = (double)feature.Properties.Value.Value,
                    ValueCosmic = extendedProperties?.ValueCosmic.HasValue == true ? (double)extendedProperties.ValueCosmic.Value : default,
                    ValueTerrestrial = extendedProperties?.ValueTerrestrial.HasValue == true ? (double)extendedProperties.ValueTerrestrial.Value : default,
                };
            }
        }
        _lastBfsFetch[kenn] = DateTime.Now;
    }

    private async IAsyncEnumerable<Measurement> FetchAndCacheAsync(string kenn, TimeSpan timeBackwards,
        [EnumeratorCancellation] CancellationToken cancellationToken)
    {
        var measurements = await CollectMeasurements24HourAsync(kenn, cancellationToken).ToArrayAsync(cancellationToken);
        if (_serviceProvider.GetService<IInfluxService>() is { } service)
        {
            await service.InsertMeasurementsAsync(measurements, cancellationToken);
        }
        foreach (var odlMeasurement in measurements)
        {
            if (odlMeasurement.Timestamp > DateTime.Now - timeBackwards)
                yield return odlMeasurement;
        }
    }

    private static async IAsyncEnumerable<Measurement> LoadCachedAsync(IInfluxService service, string kenn, TimeSpan timeBackwards,
        [EnumeratorCancellation] CancellationToken cancellationToken)
    {
        var measurements = service.GetMeasurementsAsync(start: DateTime.Now - timeBackwards, end: default, stationKenn: kenn, stationId: default,
            cancellationToken: cancellationToken);
        await foreach (var odlMeasurement in measurements.WithCancellation(cancellationToken))
        {
            Debug.Assert(odlMeasurement.Timestamp > DateTime.Now - timeBackwards);
            yield return odlMeasurement;
        }
    }

    public IAsyncEnumerable<Measurement> GetMeasurementsAsync(string kenn, TimeSpan timeBackwards, CancellationToken cancellationToken)
    {
        if (!_lastBfsFetch.TryGetValue(kenn, out var lastFetch))
            return FetchAndCacheAsync(kenn, timeBackwards, cancellationToken);

        if (DateTime.Now - lastFetch < TimeSpan.FromHours(1))
        {
            return FetchAndCacheAsync(kenn, timeBackwards, cancellationToken);
        }

        if (_serviceProvider.GetService<IInfluxService>() is { } influxService)
        {
            return LoadCachedAsync(influxService, kenn, timeBackwards, cancellationToken);
        }

        return FetchAndCacheAsync(kenn, timeBackwards, cancellationToken);
    }
}