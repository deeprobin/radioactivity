namespace RadioactivityApp.BfsClient.Tests;

public sealed class BfsExceptionTest
{
    [Theory]
    [InlineData("Lorem ipsum")]
    public void TestConstructorWithMessage(string message)
    {
        var exception = new BfsException(message);
        Assert.Equal(message, exception.Message);
    }

    [Fact]
    public void TestConstructorNull()
    {
        Assert.Throws<ArgumentNullException>(static () => new BfsException(null!));
    }
}