using RadioactivityApp.BfsClient.Models;
using System.Diagnostics;
using System.Text.Json;

namespace RadioactivityApp.BfsClient;

public sealed class BfsClient
{
    private static readonly ActivitySource ActivitySource = new($"{nameof(RadioactivityApp)}.{nameof(BfsClient)}");
    private readonly HttpClient _httpClient;
    private readonly string _baseUrl;

    public BfsClient(HttpClient httpClient, string baseUrl = "https://www.imis.bfs.de/ogc/opendata/ows/")
    {
        ArgumentNullException.ThrowIfNull(httpClient);
        ArgumentNullException.ThrowIfNull(baseUrl);

        _httpClient = httpClient;
        _baseUrl = baseUrl;
    }

    public async ValueTask<ApiResponse> PerformRequestAsync(BfsRequest request, CancellationToken cancellationToken = default)
    {
        using (ActivitySource.StartActivity())
        {
            var url = $"{_baseUrl}?{request}";
            await using var stream = await _httpClient.GetStreamAsync(url, cancellationToken);
            var response = await JsonSerializer.DeserializeAsync<ApiResponse>(stream, cancellationToken: cancellationToken);

            return ThrowHelper.ValidateResponse(response);
        }
    }
}