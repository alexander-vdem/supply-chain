USE SupplyChain;
GO

-- We are working with the assumption that replacement parts are only sourced from distributors
-- solely to simplify the data model for demonstrational purposes 

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

-- Query to find parts in the hierarchy that have substitute parts from distributors
SELECT 
    ph.PartName AS OriginalPart,
    ph.ProductID AS OriginalPartID,
    sp.Name AS SubstitutePart,
    sp.ProductID AS SubstitutePartID
FROM 
    ProductHierarchy ph
JOIN BomItems b ON ph.ProductID = b.ProductID
JOIN Product sp ON b.SubstituteProductID = sp.ProductID
JOIN Organization o ON sp.ManufacturingOrganizationID = o.OrganizationID
JOIN OrganizationTradeType ott ON o.OrganizationID = ott.OrganizationID
JOIN TradeType tt ON ott.OrganizationTradeTypeID = tt.TradeTypeID
WHERE 
    tt.TradeTypeName = 'Distributor'  -- Filter to ensure substitute parts are from distributors
    AND b.SubstituteProductID IS NOT NULL
ORDER BY 
    ph.Depth, ph.ProductID;
