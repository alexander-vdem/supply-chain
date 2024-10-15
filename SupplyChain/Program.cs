
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.DependencyInjection;
using SupplyChain.Relational;

string sqlConnectionString = "Server=172.30.57.125;Database=SupplyChain;User Id=sa;Password=YourPassword123;TrustServerCertificate=true";

var serviceProvider = new ServiceCollection()
    .AddDbContext<SupplyChainDatabaseContext>(options =>
        options.UseSqlServer(sqlConnectionString))
    .BuildServiceProvider();

DataSeed.SeedData(serviceProvider.GetRequiredService<SupplyChainDatabaseContext>());