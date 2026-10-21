using Microsoft.EntityFrameworkCore;
using TaskFlowAPI.Data;

var builder = WebApplication.CreateBuilder(args);

// Executar na porta 5000
builder.WebHost.UseUrls("http://0.0.0.0:5000");

// Registrar serviços
builder.Services.AddControllers();

// Conexão com o SQL Server
builder.Services.AddDbContext<AppDbContext>(options =>
    options.UseSqlServer(
        builder.Configuration.GetConnectionString("DefaultConnection")
    )
);

var app = builder.Build();

app.UseAuthorization();

app.MapControllers();

app.Run();