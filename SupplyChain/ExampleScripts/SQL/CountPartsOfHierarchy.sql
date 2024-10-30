USE SupplyChain;
GO

DECLARE @RootProductID INT = 1; 

WITH ProductHierarchy AS (
    -- Anchor member: Start with the root product
    SELECT p.ProductID FROM Product p WHERE p.ProductID = @RootProductID

    UNION ALL
    -- Recursive member: Find all child parts of the current level
    SELECT c.ProductID FROM ProductHierarchy ph 
	JOIN BomItems b ON ph.ProductID = b.ParentProductID
    JOIN Product c ON b.ProductID = c.ProductID
)

-- Count the total parts in the hierarchy
SELECT 
    COUNT(*) AS TotalParts
FROM 
    ProductHierarchy;
