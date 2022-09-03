using System.ComponentModel.DataAnnotations;
using System.Text.Json.Serialization;

namespace RadioactivityApp.BfsClient.Models;

public sealed record ApiResponse
{
    [Required, JsonInclude, JsonPropertyName("totalFeatures")]
    public int TotalFeatures { get; init; }

    [Required, JsonInclude, JsonPropertyName("numberReturned")]
    public int NumberReturned { get; init; }

    [Required, JsonInclude, JsonPropertyName("timeStamp")]
    public DateTime Timestamp { get; init; }

    [Required, JsonInclude, JsonPropertyName("features")]
    public IEnumerable<Feature>? Features { get; init; }
}