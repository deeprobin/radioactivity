using System.Xml;

namespace RadioactivityApp.BfsClient.Models;

public sealed record BfsRequest
{
    public string Service { get; set; } = "WFS";

    public string Request { get; set; } = "GetFeature";

    public string? TypeName { get; set; }

    public string OutputFormat { get; set; } = "application/json";

    public string? ViewParams { get; set; }

    public string? SortBy { get; set; }

    public int? MaxFeatures { get; set; }

    public int? StartIndex { get; set; }

    public XmlDocument? Filter { get; set; }

    public override string ToString()
    {
        var query = $"service={Uri.EscapeDataString(Service)}&request={Uri.EscapeDataString(Request)}&outputFormat={Uri.EscapeDataString(OutputFormat)}";
        if (TypeName != null)
        {
            query += $"&typeName={Uri.EscapeDataString(TypeName)}";
        }
        if (ViewParams != null)
        {
            query += $"&viewParams={Uri.EscapeDataString(ViewParams)}";
        }
        if (SortBy != null)
        {
            query += $"&sortBy={Uri.EscapeDataString(SortBy)}";
        }
        if (MaxFeatures != null)
        {
            query += $"&maxFeatures={Uri.EscapeDataString(MaxFeatures!.Value.ToString())}";
        }
        if (StartIndex != null)
        {
            query += $"&startIndex={Uri.EscapeDataString(StartIndex!.Value.ToString())}";
        }
        if (Filter != null)
        {
            query += $"&filter={Uri.EscapeDataString(Filter.OuterXml)}";
        }

        return query;
    }
}