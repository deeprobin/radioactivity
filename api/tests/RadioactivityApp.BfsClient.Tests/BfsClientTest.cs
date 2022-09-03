using RadioactivityApp.BfsClient.Models;
using System.Net;
using System.Net.Sockets;
using System.Text.Json;

namespace RadioactivityApp.BfsClient.Tests;

public sealed class BfsClientTest
{
    private static Task RunHttpServer(string url, string output)
    {
        return Task.Run(() =>
        {
            var listener = new HttpListener();
            listener.Prefixes.Add(url);
            listener.Start();

            // GetContext method blocks while waiting for a request.
            var context = listener.GetContext();
            var response = context.Response;

            var stream = response.OutputStream;
            var writer = new StreamWriter(stream);
            writer.Write(output);
            writer.Close();
        });
    }

    private static string GetLocalhostAddress()
    {
        var listener = new TcpListener(IPAddress.Loopback, 0);
        listener.Start();
        var port = ((IPEndPoint)listener.LocalEndpoint).Port;
        listener.Stop();

        return $"http://localhost:{port}/";
    }

    [Fact]
    public void TestConstructor()
    {
        _ = new BfsClient(new HttpClient());
    }

    [Fact]
    public void TestConstructorThrowsArgumentNullException()
    {
        Assert.Throws<ArgumentNullException>(static () => new BfsClient(null!));
        Assert.Throws<ArgumentNullException>(static () => new BfsClient(new HttpClient(), null!));
        Assert.Throws<ArgumentNullException>(static () => new BfsClient(null!, null!));
    }

    [Fact]
    public async Task TestPerformRequestAsync()
    {
        var url = GetLocalhostAddress();

        var response = new ApiResponse();
        using (RunHttpServer(url, JsonSerializer.Serialize(response)))
        {
            var client = new BfsClient(new HttpClient(), url);
            var obtainedResponse = await client.PerformRequestAsync(new BfsRequest());
            Assert.Equal(response, obtainedResponse);
        }
    }

    [Fact]
    public async Task TestPerformRequestAsyncThrowsOperationCanceledException()
    {
        var url = GetLocalhostAddress();

        var response = new ApiResponse();
        _ = RunHttpServer(url, JsonSerializer.Serialize(response));
        var client = new BfsClient(new HttpClient(), url);
        await Assert.ThrowsAsync<TaskCanceledException>(async () =>
        {
            using var cts = new CancellationTokenSource();
            var token = cts.Token;
            cts.Cancel();
            await client.PerformRequestAsync(new BfsRequest(), token);
        });
    }

    [Fact]
    public async Task TestPerformRequestAsyncThrowsHttpRequestException()
    {
        var url = GetLocalhostAddress();

        // Do not run http server!
        var client = new BfsClient(new HttpClient(), url);
        await Assert.ThrowsAsync<HttpRequestException>(async () => await client.PerformRequestAsync(new BfsRequest()));
    }
}