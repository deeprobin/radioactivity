using RadioactivityApp.BfsClient.Models;
using System.Diagnostics;
using System.Diagnostics.CodeAnalysis;

namespace RadioactivityApp.BfsClient;

internal static class ThrowHelper
{
    [DoesNotReturn]
    [StackTraceHidden]
    private static void Throw(string message)
    {
        throw new BfsException(message);
    }

    [StackTraceHidden]
    internal static ApiResponse ValidateResponse(ApiResponse? response)
    {
        if (response is null)
        {
            Throw("Received invalid API response");
        }

        return response;
    }
}