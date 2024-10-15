using System.Linq;
using Microsoft.EntityFrameworkCore;
using Models;

namespace SupplyChain.Relational;

public static class DataSeed
{
    public static void SeedData(SupplyChainDatabaseContext context)
    {
        context.Database.EnsureCreated();

        var imaginaryElectronics = new Supplier { Name = "Imaginary Electronics" };
        var acme                 = new Supplier { Name = "Acme" };
        var honest               = new Supplier { Name = "Honest Inc" };

        var testSuppliers = new List<Supplier> {imaginaryElectronics, acme, honest};
        
        if(!context.Suppliers.Any(x => testSuppliers.Select(s => s.Name).Contains(x.Name)))
        {
            context.Suppliers.AddRange(testSuppliers);
            context.SaveChanges();
        }

        var complexComputer = new Product { Name = "Complex Computer", Supplier = imaginaryElectronics };
        
        var keyboard             = new Product { Name = "Keyboard",           ParentProduct = complexComputer,      Supplier = acme,  };
        var buton                = new Product { Name = "Buton",              ParentProduct = keyboard,             Supplier = acme, };
        var keyboardInternalBody = new Product { Name = "Keyboard Internal Body", ParentProduct = keyboard,         Supplier = acme };
        var keysCircuitBoard     = new Product { Name = "Keys Circuit Board", ParentProduct = keyboardInternalBody, Supplier = acme };
        var keySwithch           = new Product { Name = "Key Switch",          ParentProduct = keysCircuitBoard,    Supplier = honest, };

        var simpleComputer  = new Product { Name = "Simple Computer", ParentProduct = complexComputer, Supplier = acme };
        var ram             = new Product { Name = "RAM",             ParentProduct = simpleComputer,  Supplier = acme };
        var transistor      = new Product { Name = "Transistor",      ParentProduct = ram,             Supplier = honest };
        var capacitor       = new Product { Name = "Capacitor",       ParentProduct = ram,             Supplier = acme };

        var hardDrive       = new Product { Name = "Hard Drive",      ParentProduct = simpleComputer, Supplier = acme };
        var magneticDisk    = new Product { Name = "Magnetic Disk",   ParentProduct = hardDrive,      Supplier = honest };
        
        var hardElectronicComponent = new Product { Name = "Hard Electronic Component", ParentProduct = hardDrive,               Supplier = acme };
        var hardDriveCircuitBoard   = new Product { Name = "Hard Drive Circuit Board",  ParentProduct = hardElectronicComponent, Supplier = acme };
        var resistor                = new Product { Name = "Resistor",                  ParentProduct = hardDriveCircuitBoard,   Supplier = acme };
        var diode                   = new Product { Name = "Diode",                     ParentProduct = hardDriveCircuitBoard,   Supplier = honest };

        var testProducts = new List<Product>
        {
            complexComputer, 
            keyboard, 
            buton, 
            keyboardInternalBody, 
            keysCircuitBoard, 
            keySwithch, 
            simpleComputer, 
            ram, 
            transistor, 
            capacitor, 
            hardDrive, 
            magneticDisk, 
            hardElectronicComponent, 
            hardDriveCircuitBoard, 
            resistor, 
            diode
        };

        if(!context.Products.Any(x => testProducts.Select(s => s.Name).Contains(x.Name)))
        {
            context.Products.AddRange(testProducts);
            context.SaveChanges();
        }
    }

    public static void SeedLargeVolumeData(SupplyChainDatabaseContext context)
    {
        context.Database.EnsureCreated();

        if (context.Products.Count() > 10000)
        {
            // High volumes of data already exist
            return;
        }

        var topLevelProductsCount = 100;
        var maxDepth = 7;
        var childrenPerLevel = 4;

        var suppliers = new List<Supplier>();
        for (int i = 0; i < topLevelProductsCount; i++)
        {
            var supplier = new Supplier { Name = $"Supplier {i+1}" };
            suppliers.Add(supplier);
        }
    
        context.Suppliers.AddRange(suppliers);
        context.SaveChanges();

        for (int i = 0; i < topLevelProductsCount; i++)
        {
            var product = new Product { Name = $"Top Level Product {i+1}", Supplier = suppliers[i] };
            var productsCreated = new List<Product> { product };
            CreateChildProduct(product, 1, maxDepth, childrenPerLevel, productsCreated, suppliers[i]);
            context.Products.AddRange(productsCreated);
            context.SaveChanges();
        }
    }

    private static void CreateChildProduct(Product parent, int currentDepth, int maxDepth, int childrenPerLevel, List<Product> productsCreated, Supplier supplier)
    {
        if (currentDepth >= maxDepth)
        {
            return;
        }

        for (int i = 0; i < childrenPerLevel; i++)
        {
            var product = new Product { Name = $" Level {currentDepth} - Child {i+1}", ParentProduct = parent, Supplier = supplier };
            productsCreated.Add(product);
            CreateChildProduct(product, currentDepth + 1, maxDepth, childrenPerLevel, productsCreated, supplier);
        }
    }
}