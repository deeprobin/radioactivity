using MediatR;

namespace RadioactivityApp.MeasuringStations.Queries;

public record struct GetAllQuery : IRequest<IEnumerable<MeasuringStation>>;