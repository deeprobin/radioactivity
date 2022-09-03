using RadioactivityApp.BfsClient.Models;

namespace RadioactivityApp.Bfs;

public interface IBfsService
{
    public ValueTask<ApiResponse> GetOdlLatest1Hour(CancellationToken cancellationToken);

    public ValueTask<ApiResponse> GetOdlTimeseries1Hour(string? kenn, CancellationToken cancellationToken);

    public ValueTask<ApiResponse> GetOdlTimeseries24Hour(string? kenn, CancellationToken cancellationToken);
}