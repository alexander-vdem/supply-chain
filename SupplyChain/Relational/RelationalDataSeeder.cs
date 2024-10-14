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

        public void CreateSchema()
        {
            CreateDatabaseIfNotExists();

            using (SqlConnection connection = new SqlConnection(_connectionString))
            {
                connection.Open();

                string createSupplierTableQuery = @"
                    IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='Supplier' and xtype='U')
                    BEGIN
                        CREATE TABLE Supplier (
                            Id INT PRIMARY KEY IDENTITY,
                            Name VARCHAR(255)
                        );
                    END";

                using (SqlCommand command = new SqlCommand(createSupplierTableQuery, connection))
                {
                    command.ExecuteNonQuery();
                }

                string createSupplyChainTableQuery = @"
                    IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='SupplyChain' and xtype='U')
                    BEGIN
                        CREATE TABLE SupplyChain (
                            Id INT PRIMARY KEY IDENTITY,
                            Supplier INT,
                            Consumer INT
                        );
                    END";

                using (SqlCommand command = new SqlCommand(createSupplyChainTableQuery, connection))
                {
                    command.ExecuteNonQuery();
                }
            }
        }
    }
}