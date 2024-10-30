USE SupplyChain;
GO

DECLARE @CatalogNumber NVARCHAR(50) = 'CC123';  -- Replace with the CatalogNumber of the product to search

WITH ProductHierarchy AS (
    -- Anchor member: Get the root product based on the given CatalogNumber
    SELECT 
        p.ProductID,
        p.Name AS PartName,
        p.CatalogNumber,
        NULL AS ParentProductID,
        0 AS HierarchyLevel
    FROM 
        Product p
    WHERE 
        p.CatalogNumber = @CatalogNumber

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
