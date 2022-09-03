namespace RadioactivityApp.Measurements;

public interface IMeasurementService
{
    public IAsyncEnumerable<Measurement> GetMeasurementsAsync(string kenn, TimeSpan timeBackwards,
        CancellationToken cancellationToken);
}