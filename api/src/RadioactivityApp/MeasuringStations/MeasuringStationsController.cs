using MediatR;
using Microsoft.AspNetCore.Mvc;
using RadioactivityApp.Infrastructure.Controllers;
using RadioactivityApp.MeasuringStations.Queries;

namespace RadioactivityApp.MeasuringStations;

public sealed class MeasuringStationsController : ApiController
{
    private readonly IMediator _mediator;

    public MeasuringStationsController(IMediator mediator)
    {
        _mediator = mediator;
    }

    [MapToApiVersion("1.0")]
    [ProducesResponseType(StatusCodes.Status200OK, Type = typeof(MeasuringStation[]))]
    [HttpGet]
    public async Task<IActionResult> GetAsync(CancellationToken cancellationToken)
    {
        var stations = await _mediator.Send(new GetAllQuery(), cancellationToken);
        return Ok(stations);
    }

    [MapToApiVersion("1.0")]
    [ProducesResponseType(StatusCodes.Status200OK, Type = typeof(MeasuringStation))]
    [ProducesResponseType(StatusCodes.Status404NotFound, Type = typeof(void))]
    [HttpGet("{kenn}")]
    public async Task<IActionResult> GetByKennAsync([FromRoute] string kenn, CancellationToken cancellationToken)
    {
        var measuringStation = await _mediator.Send(new GetByKennQuery(kenn), cancellationToken);
        if (measuringStation is null)
        {
            return NotFound($"Measurements of `{nameof(kenn)}` ({kenn}) not found");
        }

        return Ok(measuringStation);
    }
}