using MediatR;

namespace RadioactivityApp.Measurements.Queries;

internal sealed record GetByKennQuery(string Kenn, DateTime MeasurementsStartAt) : IRequest<IEnumerable<Measurement>>;