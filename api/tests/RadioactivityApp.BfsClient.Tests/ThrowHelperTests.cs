using RadioactivityApp.BfsClient.Models;

namespace RadioactivityApp.BfsClient.Tests;

public sealed class ThrowHelperTests
{
    [Fact]
    public void TestValidateResponse()
    {
        var response = new ApiResponse();
        var validationResult = ThrowHelper.ValidateResponse(response);
        Assert.Same(response, validationResult);
    }

    [Fact]
    public void TestValidateResponseNull()
    {
        Assert.Throws<BfsException>(static () => ThrowHelper.ValidateResponse(null));
    }
}