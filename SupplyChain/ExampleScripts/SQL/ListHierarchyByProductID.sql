USE SupplyChain;
GO

DECLARE @ProductID INT = 1;  -- Replace with the ProductID of the product to search

WITH ProductHierarchy AS (
    -- Anchor member: Get the root product based on the given product id
    SELECT 
        p.ProductID,
        p.Name AS PartName,
        p.CatalogNumber,
        NULL AS ParentProductID,
        0 AS HierarchyLevel
    FROM 
        Product p
    WHERE 
        p.ProductID = @ProductID

    UNION ALL

    -- Recursive member: Get all child parts
    SELECT 
        c.ProductID,
        c.Name AS PartName,
        c.CatalogNumber,
        b.ParentProductID,
        ph.HierarchyLevel + 1 AS HierarchyLevel
    FROM 
        ProductHierarchy ph
    JOIN 
        BomItems b ON ph.ProductID = b.ParentProductID
    JOIN 
        Product c ON b.ProductID = c.ProductID
)

-- Select all parts in the hierarchy for the given product
SELECT 
    ProductID,
    PartName,
    CatalogNumber,
    ParentProductID,
    HierarchyLevel
FROM 
    ProductHierarchy
ORDER BY 
    HierarchyLevel, ProductID;
