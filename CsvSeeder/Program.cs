using CsvHelper;
using System.Globalization;

namespace CsvHierarchySeeder
{
    public class Program
    {
        static void Main(string[] args)
        {
            string outputDirectory = "output";
            Directory.CreateDirectory(outputDirectory);

            string productsFile = Path.Combine(outputDirectory, "products.csv");
            string relationshipsFile = Path.Combine(outputDirectory, "relationships.csv");

            int numberOfHierarchies = 2_500; // Number of independent hierarchies
            int depth = 3; // Number of levels in each hierarchy
            int childrenPerNode = 3; // Number of children per parent

            GenerateHierarchies(productsFile, relationshipsFile, numberOfHierarchies, depth, childrenPerNode);

            Console.WriteLine("CSV files generated successfully!");
        }

        static void GenerateHierarchies(string productsFile, string relationshipsFile, int numberOfHierarchies, int depth, int childrenPerNode)
        {
            var products = new List<Product>();
            var relationships = new List<Relationship>();

            int productIdCounter = 1;

            for (int h = 1; h <= numberOfHierarchies; h++)
            {
                // Create root product for each hierarchy
                int rootId = productIdCounter++;
                products.Add(new Product
                {
                    ProductID = rootId,
                    Name = $"Root Product {h}",
                    CatalogNumber = $"CAT{rootId:000000}"
                });

                // Generate hierarchy for this root
                GenerateChildren(rootId, depth, childrenPerNode, products, relationships, ref productIdCounter);
            }

            // Write products to CSV
            WriteCsv(productsFile, products);

            // Write relationships to CSV
            WriteCsv(relationshipsFile, relationships);
        }

        static void GenerateChildren(int parentId, int depth, int childrenPerNode, List<Product> products, List<Relationship> relationships, ref int productIdCounter)
        {
            if (depth == 0) return;

            for (int i = 1; i <= childrenPerNode; i++)
            {
                int currentId = productIdCounter++;
                products.Add(new Product
                {
                    ProductID = currentId,
                    Name = $"Product {currentId}",
                    CatalogNumber = $"CAT{currentId:000000}"
                });

                relationships.Add(new Relationship
                {
                    StartID = parentId,
                    EndID = currentId,
                    Type = "IS_PARENT"
                });

                // Recursively generate children for the current node
                GenerateChildren(currentId, depth - 1, childrenPerNode, products, relationships, ref productIdCounter);
            }
        }

        static void WriteCsv<T>(string filePath, IEnumerable<T> records)
        {
            using var writer = new StreamWriter(filePath);
            using var csv = new CsvWriter(writer, CultureInfo.InvariantCulture);
            csv.WriteRecords(records);
        }
    }

    public class Product
    {
        public int ProductID { get; set; }
        public string Name { get; set; }
        public string CatalogNumber { get; set; }
    }

    public class Relationship
    {
        public int StartID { get; set; }
        public int EndID { get; set; }
        public string Type { get; set; }
    }
}
