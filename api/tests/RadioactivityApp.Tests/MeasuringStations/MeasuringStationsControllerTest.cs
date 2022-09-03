using RadioactivityApp.Tests.Infrastructure;

namespace RadioactivityApp.Tests.MeasuringStations;

public sealed class MeasuringStationsControllerTest : IClassFixture<IntegrationTestFactory>
{
    private readonly IntegrationTestFactory _factory;

    public MeasuringStationsControllerTest(IntegrationTestFactory factory)
    {
        _factory = factory;
    }

    [Fact]
    public void Test1()
    {
        using var client = _factory.CreateDefaultClient();
        // TODO
    }
}