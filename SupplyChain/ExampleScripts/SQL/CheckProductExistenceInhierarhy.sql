USE SupplyChain;
GO

DECLARE @RootProductID INT = 1;  -- Replace with the ProductID of the root product
DECLARE @TargetProductID INT = 9; -- Replace with the ProductID of the product to search for

WITH ProductHierarchy AS (
    -- Anchor member: Start with the root product
    SELECT p.ProductID FROM Product p WHERE p.ProductID = @RootProductID

    UNION ALL
    -- Recursive member: Find all child parts of the current level
    SELECT c.ProductID FROM ProductHierarchy ph
    JOIN BomItems b ON ph.ProductID = b.ParentProductID
    JOIN Product c ON b.ProductID = c.ProductID
)

-- Return product details if it exists in the hierarchy, otherwise return an empty set
SELECT p.* FROM Product p
WHERE p.ProductID = @TargetProductID
    AND EXISTS (SELECT 1 FROM ProductHierarchy WHERE ProductID = @TargetProductID);
