USE SupplyChain;
GO

DECLARE @RootProductID INT = 1;  -- Replace with the ProductID of the root product

WITH ProductHierarchy AS (
    -- Anchor member: Start with the root product
    SELECT p.ProductID, p.Name AS PartName, 0 AS Depth
    FROM Product p WHERE p.ProductID = @RootProductID

    UNION ALL

    -- Recursive member: Find all child parts of the current level
    SELECT c.ProductID, c.Name AS PartName, ph.Depth + 1 AS Depth
    FROM ProductHierarchy ph
    JOIN BomItems b ON ph.ProductID = b.ParentProductID
    JOIN Product c ON b.ProductID = c.ProductID
)

-- Query to find distributor organizations supplying spare parts in the hierarchy
SELECT DISTINCT
    o.OrganizationID,
    o.Name AS SupplierName,
    sp.ProductID AS SparePartID,
    sp.Name AS SparePartName
FROM 
    ProductHierarchy ph
JOIN BomItems b ON ph.ProductID = b.ProductID
JOIN Product sp ON b.SubstituteProductID = sp.ProductID
JOIN Organization o ON sp.ManufacturingOrganizationID = o.OrganizationID
JOIN OrganizationTradeType ott ON o.OrganizationID = ott.OrganizationID
JOIN TradeType tt ON ott.OrganizationTradeTypeID = tt.TradeTypeID
WHERE 
    b.SubstituteProductID IS NOT NULL  -- Filter for spare parts
    AND tt.TradeTypeName = 'Distributor'  -- Filter to include only distributor organizations
ORDER BY 
    SupplierName;
