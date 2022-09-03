using Polly;

namespace RadioactivityApp.Bfs;

using BfsClient;
using BfsClient.Models;

internal sealed class BfsService : IBfsService
{
    private static readonly TimeSpan[] SleepDurations = {
        TimeSpan.Zero,
        TimeSpan.FromSeconds(1),
        TimeSpan.FromSeconds(3),
        TimeSpan.FromSeconds(5),
        TimeSpan.FromSeconds(10)
    };

    private readonly BfsClient _bfsClient;

    public BfsService(HttpClient httpClient)
    {
        _bfsClient = new BfsClient(httpClient);
    }

    private async ValueTask<ApiResponse> PerformRequestAsync(BfsRequest request, CancellationToken cancellationToken)
    {
        return await Policy
            .Handle<HttpRequestException>()
            .WaitAndRetryAsync(SleepDurations)
            .ExecuteAsync(async ct => await _bfsClient.PerformRequestAsync(request, ct), cancellationToken);
    }

    public ValueTask<ApiResponse> GetOdlLatest1Hour(CancellationToken cancellationToken)
    {
        return PerformRequestAsync(new BfsRequest
        {
            TypeName = "opendata:odlinfo_odl_1h_latest"
        }, cancellationToken);
    }

    public ValueTask<ApiResponse> GetOdlTimeseries1Hour(string? kenn, CancellationToken cancellationToken)
    {
        return PerformRequestAsync(new BfsRequest
        {
            TypeName = "opendata:odlinfo_timeseries_odl_1h",
            ViewParams = $"kenn:{kenn}"
        }, cancellationToken);
    }

    public ValueTask<ApiResponse> GetOdlTimeseries24Hour(string? kenn, CancellationToken cancellationToken)
    {
        return PerformRequestAsync(new BfsRequest
        {
            TypeName = "opendata:odlinfo_timeseries_odl_24h",
            ViewParams = $"kenn:{kenn}"
        }, cancellationToken);
    }
}