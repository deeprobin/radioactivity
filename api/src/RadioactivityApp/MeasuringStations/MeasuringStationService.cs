using F23.StringSimilarity;
using Microsoft.Extensions.Caching.Distributed;
using RadioactivityApp.Bfs;
using System.Diagnostics;
using System.Runtime.CompilerServices;
using System.Text.Json;

namespace RadioactivityApp.MeasuringStations;

public sealed class MeasuringStationService : IMeasuringStationService
{
    private readonly IBfsService _bfsService;
    private readonly IDistributedCache _cache;
    private readonly ILogger<MeasuringStationService> _logger;
    private readonly JaroWinkler _jaroWinkler;

    public MeasuringStationService(IBfsService bfsService, IDistributedCache cache, ILogger<MeasuringStationService> logger)
    {
        _bfsService = bfsService;
        _cache = cache;
        _logger = logger;
        _jaroWinkler = new JaroWinkler();
    }

    public async IAsyncEnumerable<MeasuringStation> GetMeasuringStationsAsync([EnumeratorCancellation] CancellationToken cancellationToken)
    {
        if (await _cache.GetStringAsync("ms:all", cancellationToken) is { } cached)
        {
            var deserialized = JsonSerializer.Deserialize<IEnumerable<MeasuringStation>>(cached);
            foreach (var item in deserialized!)
            {
                yield return item;
            }
        }
        else
        {
            var stations = await GetMeasuringStationsBfsAsync(cancellationToken).ToArrayAsync(cancellationToken);
            await _cache.SetStringAsync("ms:all", JsonSerializer.Serialize(stations), cancellationToken);

            foreach (var measuringStation in stations)
            {
                yield return measuringStation;
            }
        }
    }

    public async ValueTask<MeasuringStation?> GetMeasuringStationByKennAsync(string kenn, CancellationToken cancellationToken)
    {
        // Use `kenn`-cache
        var jsonResponse = await _cache.GetStringAsync($"ms:kenn:{kenn}", cancellationToken);
        if (jsonResponse != null)
        {
            return JsonSerializer.Deserialize<MeasuringStation>(jsonResponse);
        }

        // Use `all`-cache or fetch from bfs
        return await GetMeasuringStationsAsync(cancellationToken)
            .FirstOrDefaultAsync(measuringStation => measuringStation.Kenn == kenn, cancellationToken);
    }

    public IAsyncEnumerable<MeasuringStation> GetMeasuringStationsByZipCodeAsync(string zipCode, CancellationToken cancellationToken)
    {
        return GetMeasuringStationsAsync(cancellationToken).Where(measuringStation => zipCode == measuringStation.ZipCode);
    }

    public IAsyncEnumerable<MeasuringStation> GetMeasuringStationsBySearchQueryAsync(string query, CancellationToken cancellationToken)
    {
        return GetMeasuringStationsBySearchQueryCoreAsync(query, cancellationToken)
            .Where(static ms => ms.Similarity > 0.6)
            .OrderByDescending(static ms => ms.Similarity)
            .Select(static ms => ms.Station);
    }

    private async IAsyncEnumerable<(double Similarity, MeasuringStation Station)>
        GetMeasuringStationsBySearchQueryCoreAsync(string query, [EnumeratorCancellation] CancellationToken cancellationToken)
    {
        await foreach (var measuringStation in GetMeasuringStationsAsync(cancellationToken))
        {
            if (measuringStation.Name != null)
            {
                var similarity = _jaroWinkler.Similarity(measuringStation.Name, query);
                yield return (similarity, measuringStation);
            }

            if (measuringStation.ZipCode != null)
            {
                var similarity = _jaroWinkler.Similarity(measuringStation.Name, query);
                yield return (similarity, measuringStation);
            }
        }
    }

    private async IAsyncEnumerable<MeasuringStation> GetMeasuringStationsBfsAsync([EnumeratorCancellation] CancellationToken cancellationToken)
    {
        var latestHour = await _bfsService.GetOdlLatest1Hour(cancellationToken);
        if (latestHour.Features is null)
        {
            _logger.LogError("BFS-API returned no features");
            yield break;
        }
        foreach (var feature in latestHour.Features)
        {
            if (feature.Properties is null)
            {
                _logger.LogError("BFS-API returned no properties");
                yield break;
            }
            if (feature.Geometry!.Coordinates is null)
            {
                _logger.LogError("BFS-API returned no geometry ({Kenn})", feature.Properties.Kenn);
                yield break;
            }
            var coordinates = feature.Geometry.Coordinates.ToArray();
            Debug.Assert(coordinates.Length == 2);
            yield return new MeasuringStation
            {
                Kenn = feature.Properties.Kenn ?? "",
                Latitude = coordinates[0],
                Longitude = coordinates[1],
                Name = feature.Properties.Name,
                ZipCode = feature.Properties.Plz,
            };
        }
    }

    public IAsyncEnumerable<MeasuringStation> GetNearbyMeasuringStationsAsync(double latitude, double longitude,
        double radius, CancellationToken cancellationToken)
    {
        return GetMeasuringStationsAsync(cancellationToken).Where(ms => GetDistance(latitude, longitude, ms.Latitude, ms.Longitude) <= radius);
    }

    private static double GetDistance(double lat1, double long1, double lat2, double long2)
    {
        const double metreConstant = 6471e3;
        var w = lat1 * Math.PI / 180;
        var x = lat2 * Math.PI / 180;
        var y = (lat2 - lat1) * Math.PI / 180;
        var z = (long2 - long1) * Math.PI / 180;

        var a = Math.Sin(y / 2) * Math.Sin(y / 2)
                + Math.Cos(w) * Math.Cos(x) +
                Math.Sin(z / 2) * Math.Sin(z / 2);
        var c = 2 * Math.Atan2(Math.Sqrt(a), Math.Sqrt(1 - a));
        return c * metreConstant;
    }
}