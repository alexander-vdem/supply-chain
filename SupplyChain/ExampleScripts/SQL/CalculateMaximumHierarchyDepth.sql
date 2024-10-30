USE SupplyChain;
GO

DECLARE @RootProductID INT = 1;  -- Replace with the ProductID of the root product

WITH ProductHierarchy AS (
    -- Anchor member: Start with the root product at depth 0
    SELECT p.ProductID, 0 AS Depth FROM Product p WHERE p.ProductID = @RootProductID

    UNION ALL

    -- Recursive member: Increment depth for each level in the hierarchy
    SELECT c.ProductID, ph.Depth + 1 AS Depth FROM  ProductHierarchy ph
    JOIN BomItems b ON ph.ProductID = b.ParentProductID
    JOIN Product c ON b.ProductID = c.ProductID
)

-- Select the maximum depth
SELECT 
    MAX(Depth) AS MaximumDepth
FROM 
    ProductHierarchy;
