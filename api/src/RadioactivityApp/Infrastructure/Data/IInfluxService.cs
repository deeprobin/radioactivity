using RadioactivityApp.Measurements;

namespace RadioactivityApp.Infrastructure.Data;

public interface IInfluxService
{
    public ValueTask InsertMeasurementsAsync(IEnumerable<Measurement> measurements, CancellationToken cancellationToken);

    public IAsyncEnumerable<Measurement> GetMeasurementsAsync(DateTime? start, DateTime? end, string? stationId,
        string? stationKenn, bool mustBeValidated = false, CancellationToken cancellationToken = default);
}