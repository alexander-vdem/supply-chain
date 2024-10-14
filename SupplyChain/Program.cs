using SupplyChain.Relational;

string sqlConnectionString = "Server=172.30.57.125,1433;Database=SupplyChain;User Id=SA;Password=YourPassword123;";

var sqlSeeder = new RelationalDataSeeder(sqlConnectionString);

sqlSeeder.Seed();
