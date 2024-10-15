
using System.Diagnostics;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.DependencyInjection;
using Relational;
using SupplyChain.Relational;

string sqlConnectionString = "Server=172.30.57.125;Database=SupplyChain;User Id=sa;Password=YourPassword123;TrustServerCertificate=true";

var serviceProvider = new ServiceCollection()
    .AddDbContext<SupplyChainDatabaseContext>(options =>
        options.UseSqlServer(sqlConnectionString))
    .BuildServiceProvider();

var databaseContext = serviceProvider.GetRequiredService<SupplyChainDatabaseContext>();

DataSeed.SeedData(databaseContext);

Stopwatch  stopwatch = new Stopwatch();
stopwatch.Start();

var result = BomStore.GetPartsUnderComplexComputerBySupplier(databaseContext,"Complex Computer", "Honest Inc");
stopwatch.Stop();

Console.WriteLine($"Entity framework executed in: {stopwatch.ElapsedMilliseconds} ms");

stopwatch.Restart();
stopwatch.Start();

var resultCTE = BomStore.GetPartsUnderComplexComputerCTE(databaseContext,"Complex Computer", "Honest Inc");
stopwatch.Stop();

Console.WriteLine($"CTE executed in: {stopwatch.ElapsedMilliseconds} ms");

