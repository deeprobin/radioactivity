using MediatR;
using System.Diagnostics;

namespace RadioactivityApp.MeasuringStations.Queries.Handlers;

internal sealed class GetByKennHandler : IRequestHandler<GetByKennQuery, MeasuringStation?>
{
    private static readonly ActivitySource ActivitySource = new(nameof(RadioactivityApp));
    private readonly IMeasuringStationService _measuringStationService;

    public GetByKennHandler(IMeasuringStationService measuringStationService)
    {
        _measuringStationService = measuringStationService;
    }

    public async Task<MeasuringStation?> Handle(GetByKennQuery request, CancellationToken cancellationToken)
    {
        using (ActivitySource.StartActivity())
        {
            return await _measuringStationService.GetMeasuringStationByKennAsync(request.Kenn, cancellationToken);
        }
    }
}