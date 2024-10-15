using Microsoft.EntityFrameworkCore;
using Models;
using SupplyChain.Relational;

namespace Relational;

public class BomStore
{
    public BomStore(SupplyChainDatabaseContext context)
    {
        _context = context;
    }

    private SupplyChainDatabaseContext _context;

    public List<Product> GetSubProductsBySupplier(string productName, string supplierName)
    {
        var complexComputer = _context.Products
            .FirstOrDefault(p => p.Name == productName);

        if (complexComputer == null)
        {
            return new List<Product>();
        }

        var supplierId = _context.Suppliers.Where(s => s.Name == supplierName).Select(s => s.Id).FirstOrDefault();

        var result = new List<Product>();
        GetPartsRecursive( complexComputer.Id, supplierId, result);
        return result;
    }

    public List<Product> GetSubProductsBySupplierCTE(string productName, string supplierName)
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

        var products = _context.Products.FromSqlRaw(query, productName, supplierName).ToList();
        return products;
    }

    private void GetPartsRecursive(int parentId, int supplierId, List<Product> result)
    {
        var childParts = _context.Products
            .Where(p => p.ParentProductId == parentId)
            .ToList();

        foreach (var child in childParts)
        {
            if (child.SupplierId == supplierId)
            {
                result.Add(child);
            }
            GetPartsRecursive(child.Id, supplierId, result);
        }
    }
}