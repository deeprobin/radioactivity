using System.ComponentModel.DataAnnotations;
using System.Text.Json.Serialization;

namespace RadioactivityApp.BfsClient.Models;

public sealed record Feature
{
    [Required, JsonInclude, JsonPropertyName("id")]
    public string? Id { get; init; }

    [Required, JsonInclude, JsonPropertyName("geometry")]
    public GeometryPoint? Geometry { get; init; }

    [Required, JsonInclude, JsonPropertyName("geometryName")]
    public string? GeometryName { get; init; }

    [Required, JsonInclude, JsonPropertyName("properties")]
    public FeatureProperties? Properties { get; init; }
}