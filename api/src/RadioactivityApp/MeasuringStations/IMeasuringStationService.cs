namespace RadioactivityApp.MeasuringStations;

public interface IMeasuringStationService
{
    public IAsyncEnumerable<MeasuringStation> GetMeasuringStationsAsync(CancellationToken cancellationToken);

    public ValueTask<MeasuringStation?> GetMeasuringStationByKennAsync(string kenn, CancellationToken cancellationToken);

    public IAsyncEnumerable<MeasuringStation> GetMeasuringStationsByZipCodeAsync(string zipCode, CancellationToken cancellationToken);

    public IAsyncEnumerable<MeasuringStation> GetMeasuringStationsBySearchQueryAsync(string plz, CancellationToken cancellationToken);

    public IAsyncEnumerable<MeasuringStation> GetNearbyMeasuringStationsAsync(double latitude, double longitude, double radius, CancellationToken cancellationToken);
}