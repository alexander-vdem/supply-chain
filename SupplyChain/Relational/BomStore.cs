using Microsoft.EntityFrameworkCore;
using Models;
using SupplyChain.Relational;

namespace Relational;

public static class BomStore
{
    public static List<Product> GetPartsUnderComplexComputerBySupplier(SupplyChainDatabaseContext context, string productName, string supplierName)
    {
        var complexComputer = context.Products
            .FirstOrDefault(p => p.Name == productName);

        if (complexComputer == null)
        {
            return new List<Product>();
        }

        var supplierId = context.Suppliers.Where(s => s.Name == supplierName).Select(s => s.Id).FirstOrDefault();

        var result = new List<Product>();
        GetPartsRecursive(context, complexComputer.Id, supplierId, result);
        return result;
    }

    public static List<Product> GetPartsUnderComplexComputerCTE(SupplyChainDatabaseContext context, string productName, string supplierName)
    {
        var query = @"
        WITH ProductHierarchy AS (
            SELECT p.Id, p.Name, p.SupplierId, p.ParentProductId
            FROM Products p
            WHERE p.Name = {0}
            UNION ALL
            SELECT p.Id, p.Name, p.SupplierId, p.ParentProductId
            FROM Products p
            INNER JOIN ProductHierarchy ph ON p.ParentProductId = ph.Id
        )
        SELECT ph.*
        FROM ProductHierarchy ph
        INNER JOIN Suppliers s ON ph.SupplierId = s.Id
        WHERE s.Name = {1}";

        var products = context.Products.FromSqlRaw(query, productName, supplierName).ToList();
        return products;
    }

    private static void GetPartsRecursive(SupplyChainDatabaseContext context, int parentId, int supplierId, List<Product> result)
    {
        var childParts = context.Products
            .Where(p => p.ParentProductId == parentId)
            .ToList();

        foreach (var child in childParts)
        {
            if (child.SupplierId == supplierId)
            {
                result.Add(child);
            }
            GetPartsRecursive(context, child.Id, supplierId, result);
        }
    }
}