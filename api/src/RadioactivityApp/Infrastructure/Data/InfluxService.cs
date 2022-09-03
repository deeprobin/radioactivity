using InfluxDB.Client;
using InfluxDB.Client.Api.Domain;
using RadioactivityApp.Measurements;
using System.Runtime.CompilerServices;
using System.Text;

namespace RadioactivityApp.Infrastructure.Data;

public sealed class InfluxService : IInfluxService
{
    private const string Bucket = "radioactivity";
    private const string Org = "radioactivity";

    private readonly IInfluxDBClient _client;
    private readonly ILogger<InfluxService> _logger;
    private bool _setupDone;

    public InfluxService(IInfluxDBClient client, ILogger<InfluxService> logger)
    {
        _client = client;
        _logger = logger;
    }

    private async ValueTask Setup(CancellationToken cancellationToken)
    {
        var organizations = _client.GetOrganizationsApi();
        var org = (await organizations.FindOrganizationsAsync(org: Org,
            cancellationToken: cancellationToken))?.FirstOrDefault() ?? await organizations.CreateOrganizationAsync(Org, cancellationToken);

        var buckets = _client.GetBucketsApi();
        var bucket = await buckets.FindBucketByNameAsync(Bucket, cancellationToken);

        if (bucket is null)
        {
            await buckets.CreateBucketAsync(Bucket, new BucketRetentionRules(BucketRetentionRules.TypeEnum.Expire, 60 * 60 * 24 * 365 * 5 /* 5 years */), org, cancellationToken);
        }

        _setupDone = true;
    }

    public async ValueTask InsertMeasurementsAsync(IEnumerable<Measurement> measurements, CancellationToken cancellationToken)
    {
        if (!_setupDone)
        {
            await Setup(cancellationToken);
        }
        var writeApi = _client.GetWriteApiAsync();
        await writeApi.WriteMeasurementsAsync(measurements.ToArray(), WritePrecision.Ns, Bucket, Org, cancellationToken);
    }

    public async IAsyncEnumerable<Measurement> GetMeasurementsAsync(DateTime? start, DateTime? end, string? stationId, string? stationKenn, bool mustBeValidated = false, [EnumeratorCancellation] CancellationToken cancellationToken = default)
    {
        await Setup(cancellationToken);
        var queryApi = _client.GetQueryApi();
        var queryBuilder = new StringBuilder($"from(bucket:\"{Bucket}\")");
        if (stationId is not null)
        {
            queryBuilder.Append($" |> filter(fn: (r) => r.station_id == \"{stationId}\")");
        }
        if (stationKenn is not null)
        {
            queryBuilder.Append($" |> filter(fn: (r) => r.station_kenn == \"{stationKenn}\")");
        }
        if (mustBeValidated)
        {
            queryBuilder.Append(" |> filter(fn: (r) => r.validated == true)");
        }

        if (start is not null && end is not null)
        {
            queryBuilder.Append(
                $" |> range(start: {((DateTimeOffset)start.Value).ToUnixTimeMilliseconds()}, stop: {((DateTimeOffset)end.Value).ToUnixTimeMilliseconds()})");
        }
        else
        {
            if (start is not null)
            {
                queryBuilder.Append(
                    $" |> range(start: {((DateTimeOffset)start.Value).ToUnixTimeMilliseconds()})");
            }
            if (end is not null)
            {
                queryBuilder.Append(
                    $" |> range(stop: {((DateTimeOffset)end.Value).ToUnixTimeMilliseconds()})");
            }
        }

        await foreach (var measurement in queryApi.QueryAsyncEnumerable<Measurement>(queryBuilder.ToString(), Org, cancellationToken))
        {
            yield return measurement;
        }
    }
}