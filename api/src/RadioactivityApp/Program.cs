using InfluxDB.Client;
using MediatR;
using MediatR.Registration;
using OpenTelemetry.Trace;
using RadioactivityApp.Bfs;
using RadioactivityApp.Infrastructure.Data;
using RadioactivityApp.Measurements;
using RadioactivityApp.MeasuringStations;
using RadioactivityApp.MeasuringStations.Queries;
using RadioactivityApp.MeasuringStations.Queries.Handlers;

namespace RadioactivityApp;

public sealed class Program
{
    public static void Main(string[] args)
    {
        var builder = WebApplication.CreateBuilder(args);

        builder.Services.AddControllers();
        builder.Services.AddApiVersioning();

        builder.Services.AddEndpointsApiExplorer();
        builder.Services.AddSwaggerGen();

        #region Caching

        if (builder.Environment.IsDevelopment())
        {
            builder.Services.AddDistributedMemoryCache();
        }
        else
        {
            builder.Services.AddDistributedRedisCache(options =>
            {
                options.Configuration = builder.Configuration["RedisConnectionString"];
            });
        }
        if (string.IsNullOrEmpty(builder.Configuration["InfluxConnectionString"]))
        {
            Console.Error.WriteLine("InfluxConnectionString is unset.");
            if (!builder.Environment.IsDevelopment())
            {
                Environment.Exit(1);
            }
        }
        else
        {
            if (string.IsNullOrEmpty(builder.Configuration["InfluxConnectionToken"]))
            {
                if (!string.IsNullOrEmpty(builder.Configuration["InfluxUser"]) &&
                    !string.IsNullOrEmpty(builder.Configuration["InfluxPassword"]))
                {
                    builder.Services.AddScoped<IInfluxDBClient>(_ => InfluxDBClientFactory.Create(
                        builder.Configuration["InfluxConnectionString"], builder.Configuration["InfluxUser"], builder.Configuration["InfluxPassword"].ToCharArray()));
                }
                else
                {
                    builder.Services.AddScoped<IInfluxDBClient>(_ => InfluxDBClientFactory.Create(
                        builder.Configuration["InfluxConnectionString"]));
                }
            }
            else
            {
                builder.Services.AddScoped<IInfluxDBClient>(_ => InfluxDBClientFactory.Create(
                    builder.Configuration["InfluxConnectionString"],
                    builder.Configuration["InfluxConnectionToken"]));
            }

            builder.Services.AddScoped<IInfluxService, InfluxService>();
        }

        builder.Services.AddResponseCaching();

        #endregion Caching

        #region Telemetry

        builder.Services.AddApplicationInsightsTelemetry();
        builder.Services.AddOpenTelemetryTracing(static options =>
        {
            options.AddJaegerExporter();
            options.AddZipkinExporter();
            options.AddOtlpExporter();

            options.AddAspNetCoreInstrumentation();
            options.AddHttpClientInstrumentation();
            options.AddRedisInstrumentation();
        });

        #endregion Telemetry

        builder.Services.AddHttpClient();
        builder.Services.AddScoped<IBfsService, BfsService>();
        builder.Services.AddScoped<IMeasurementService, MeasurementService>();
        builder.Services.AddScoped<IMeasuringStationService, MeasuringStationService>();

        #region MediatR

        ServiceRegistrar.AddRequiredServices(builder.Services, new MediatRServiceConfiguration());

        // Manually register the types as scoped services for better diagnostics and startup performance.
        builder.Services.AddScoped<IRequestHandler<Measurements.Queries.GetByKennQuery, IEnumerable<Measurement>>, Measurements.Queries.Handlers.GetByKennHandler>();
        builder.Services.AddScoped<IRequestHandler<GetByKennQuery, MeasuringStation?>, GetByKennHandler>();
        builder.Services.AddScoped<IRequestHandler<GetAllQuery, IEnumerable<MeasuringStation>>, GetAllHandler>();

        #endregion MediatR

        var app = builder.Build();

        // Configure the HTTP request pipeline.
        if (app.Environment.IsDevelopment())
        {
            app.UseSwagger();
            app.UseSwaggerUI();
        }

        // app.UseHttpsRedirection();
        app.UseAuthorization();
        app.MapControllers();
        app.Run();
    }
}