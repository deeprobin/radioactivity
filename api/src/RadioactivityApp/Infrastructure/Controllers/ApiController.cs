﻿using Microsoft.AspNetCore.Mvc;

namespace RadioactivityApp.Infrastructure.Controllers;

[ApiController]
[Route("api/v{version:apiVersion}/[controller]")]
[ApiVersion("1.0")]
public abstract class ApiController : ControllerBase
{
}