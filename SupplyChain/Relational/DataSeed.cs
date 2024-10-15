using Models;

namespace SupplyChain.Relational;

public static class DataSeed
{
    public static void SeedData(SupplyChainDatabaseContext context)
    {
        context.Database.EnsureCreated();

        if (!context.Products.Any())
        {
            context.Products.RemoveRange(context.Products);
            context.SaveChanges();
        }

        if (!context.Suppliers.Any())
        {
            context.Suppliers.RemoveRange(context.Suppliers);
            context.SaveChanges();
        }
        
        var imaginaryElectronics = new Supplier { Name = "Imaginary Electronics" };
        var acme                 = new Supplier { Name = "Acme" };
        var honest            = new Supplier { Name = "Honest Inc" };

        context.Suppliers.AddRange(imaginaryElectronics, acme);

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

        context.Products.AddRange(
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
            diode);
        
        context.SaveChanges();
    }
}