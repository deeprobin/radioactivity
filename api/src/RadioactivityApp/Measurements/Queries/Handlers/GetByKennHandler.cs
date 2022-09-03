using MediatR;
using System.Diagnostics;

namespace RadioactivityApp.Measurements.Queries.Handlers;

internal sealed class GetByKennHandler : IRequestHandler<GetByKennQuery, IEnumerable<Measurement>>
{
    private static readonly ActivitySource ActivitySource = new(nameof(RadioactivityApp));
    private readonly IMeasurementService _measurementService;

    public GetByKennHandler(IMeasurementService measurementService)
    {
        _measurementService = measurementService;
    }

    public async Task<IEnumerable<Measurement>> Handle(GetByKennQuery request, CancellationToken cancellationToken)
    {
        using (ActivitySource.StartActivity())
        {
            var enumerable = _measurementService.GetMeasurementsAsync(request.Kenn, DateTime.Now - request.MeasurementsStartAt, cancellationToken);
            return await enumerable.ToListAsync(cancellationToken);
        }
    }
}