using System.Data.SqlClient;

namespace SupplyChain.Relational
{
    public class RelationalDataSeeder
    {
        private readonly string _connectionString;

        public RelationalDataSeeder(string connectionString)
        {
            _connectionString = connectionString;
        }

        private void CreateDatabaseIfNotExists()
        {
            var builder = new SqlConnectionStringBuilder(_connectionString)
            {
                InitialCatalog = "master"
            };

            using (SqlConnection connection = new SqlConnection(builder.ConnectionString))
            {
                connection.Open();

                string checkDbQuery = @"
                    IF NOT EXISTS (SELECT * FROM sys.databases WHERE name = 'SupplyChain')
                    BEGIN
                    CREATE DATABASE SupplyChain;
                    END";

                using (SqlCommand command = new SqlCommand(checkDbQuery, connection))
                {
                    command.ExecuteNonQuery();
                }
            }
        }

        public void Seed()
        {
            CreateDatabaseIfNotExists();
        }
    }
}