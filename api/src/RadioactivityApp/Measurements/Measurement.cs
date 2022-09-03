using InfluxDB.Client.Core;
using System.Text.Json.Serialization;
using MeasurementAttribute = InfluxDB.Client.Core.Measurement;

namespace RadioactivityApp.Measurements;

[Measurement("odl")]
public sealed class Measurement
{
    [Column("station_id", IsTag = true)]
    [JsonIgnore]
    public string? Id { get; set; }

    [Column("station_kenn", IsTag = true)]
    [JsonIgnore]
    public string? Kenn { get; set; }

    [Column("timestamp", IsTimestamp = true)]
    [JsonInclude]
    public DateTime Timestamp { get; set; }

    [Column("value")]
    [JsonInclude]
    public double Value { get; set; }

    [Column("cosmic_value")]
    [JsonInclude]
    public double? ValueCosmic { get; set; }

    [Column("terrestrial_value")]
    [JsonInclude]
    public double? ValueTerrestrial { get; set; }

    [Column("unit", IsTag = true)]
    [JsonInclude]
    public string? Unit { get; set; }

    [Column("nuclide", IsTag = true)]
    [JsonInclude]
    public string? Nuclide { get; set; }

    [Column("validated", IsTag = true)]
    [JsonInclude]
    public bool Validated { get; set; }
}