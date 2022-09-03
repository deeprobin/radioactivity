using MediatR;
using System.Diagnostics;

namespace RadioactivityApp.MeasuringStations.Queries.Handlers;

public sealed class GetAllHandler : IRequestHandler<GetAllQuery, IEnumerable<MeasuringStation>>
{
    private static readonly ActivitySource ActivitySource = new(nameof(RadioactivityApp));
    private readonly IMeasuringStationService _measuringStationService;

    public GetAllHandler(IMeasuringStationService measuringStationService)
    {
        _measuringStationService = measuringStationService;
    }

    public async Task<IEnumerable<MeasuringStation>> Handle(GetAllQuery request, CancellationToken cancellationToken)
    {
        using (ActivitySource.StartActivity())
        {
            var stationEnumerable = _measuringStationService.GetMeasuringStationsAsync(cancellationToken);
            return await stationEnumerable.ToListAsync(cancellationToken);
        }
    }
}