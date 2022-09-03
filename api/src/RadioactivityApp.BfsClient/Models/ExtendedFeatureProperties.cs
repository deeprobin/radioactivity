using System.ComponentModel.DataAnnotations;
using System.Text.Json.Serialization;

namespace RadioactivityApp.BfsClient.Models;

public sealed record ExtendedFeatureProperties : FeatureProperties
{
    [Required, JsonInclude, JsonPropertyName("site_status")]
    public string? SiteStatus { get; init; }
    [Required, JsonInclude, JsonPropertyName("kid")]
    public int Kid { get; init; }
    [Required, JsonInclude, JsonPropertyName("height_about_sea")]
    public decimal HeightAboutSea { get; init; }
    [JsonInclude, JsonPropertyName("value_cosmic")]
    public decimal? ValueCosmic { get; init; }
    [JsonInclude, JsonPropertyName("value_terrestrial")]
    public decimal? ValueTerrestrial { get; init; }
}