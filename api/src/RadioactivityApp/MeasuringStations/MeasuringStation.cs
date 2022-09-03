namespace RadioactivityApp.MeasuringStations;

public sealed class MeasuringStation
{
    public string Kenn { get; init; } = "";
    public double Latitude { get; init; }
    public double Longitude { get; init; }
    public string? ZipCode { get; init; }
    public string? Name { get; init; }
}