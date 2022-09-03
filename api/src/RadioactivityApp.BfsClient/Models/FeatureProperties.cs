using System.ComponentModel.DataAnnotations;
using System.Text.Json.Serialization;

namespace RadioactivityApp.BfsClient.Models;

public record FeatureProperties
{
    [Required, JsonInclude, JsonPropertyName("id")]
    public string? Id { get; init; }
    [Required, JsonInclude, JsonPropertyName("kenn")]
    public string? Kenn { get; init; }
    [JsonInclude, JsonPropertyName("plz")]
    public string? Plz { get; init; }
    [Required, JsonInclude, JsonPropertyName("name")]
    public string? Name { get; init; }
    [JsonInclude, JsonPropertyName("start_measure")]
    public DateTime? StartMeasure { get; init; }
    [JsonInclude, JsonPropertyName("end_measure")]
    public DateTime? EndMeasure { get; init; }
    [JsonInclude, JsonPropertyName("value")]
    public decimal? Value { get; init; }
    [Required, JsonInclude, JsonPropertyName("unit")]
    public string? Unit { get; init; }
    [JsonInclude, JsonPropertyName("validated")]
    public int? Validated { get; init; }
    [Required, JsonInclude, JsonPropertyName("nuclide")]
    public string? Nuclide { get; init; }
    [Required, JsonInclude, JsonPropertyName("duration")]
    public string? Duration { get; init; }
}