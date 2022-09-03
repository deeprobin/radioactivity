using MediatR;
using Microsoft.AspNetCore.Mvc;
using RadioactivityApp.Infrastructure.Controllers;

namespace RadioactivityApp.Measurements;

public sealed class MeasurementsController : ApiController
{
    private readonly IMediator _mediator;

    public MeasurementsController(IMediator mediator)
    {
        _mediator = mediator;
    }

    [MapToApiVersion("1.0")]
    [ProducesResponseType(StatusCodes.Status200OK, Type = typeof(Measurement[]))]
    [ProducesResponseType(StatusCodes.Status404NotFound, Type = typeof(void))]
    [HttpGet("{kenn}")]
    public async Task<IActionResult> GetByKennAsync([FromRoute] string kenn, [FromQuery(Name = "start")] DateTime? measurementsStartAt, CancellationToken cancellationToken)
    {
        measurementsStartAt ??= DateTime.Now - TimeSpan.FromDays(1);
        var measuringStation = await _mediator.Send(new MeasuringStations.Queries.GetByKennQuery(kenn), cancellationToken);
        if (measuringStation is null)
        {
            return NotFound($"Measurements of `{nameof(kenn)}` ({kenn}) not found");
        }

        var measurements = await _mediator.Send(new Queries.GetByKennQuery(kenn, measurementsStartAt ?? DateTime.Now - TimeSpan.FromDays(1)), cancellationToken);
        return Ok(measurements);
    }
}