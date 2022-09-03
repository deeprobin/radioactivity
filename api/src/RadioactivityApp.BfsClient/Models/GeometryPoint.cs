using System.ComponentModel.DataAnnotations;
using System.Text.Json.Serialization;

namespace RadioactivityApp.BfsClient.Models;

public sealed record GeometryPoint
{
    [Required, JsonInclude, JsonPropertyName("coordinates")]
    public IEnumerable<double>? Coordinates { get; init; }
}