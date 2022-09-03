using MediatR;

namespace RadioactivityApp.MeasuringStations.Queries;

internal sealed record GetByKennQuery(string Kenn) : IRequest<MeasuringStation?>;