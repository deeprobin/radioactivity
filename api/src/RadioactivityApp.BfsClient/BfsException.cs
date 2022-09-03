namespace RadioactivityApp.BfsClient;

public sealed class BfsException : Exception
{
    internal BfsException(string message) : base(message)
    {
        ArgumentNullException.ThrowIfNull(message);
    }
}