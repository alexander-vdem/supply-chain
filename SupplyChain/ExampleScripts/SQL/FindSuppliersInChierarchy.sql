USE SupplyChain;
GO

DECLARE @RootProductID INT = 1;  -- Replace with the ProductID of the root product

-- Find the supplier of the root product
DECLARE @RootSupplierID INT;
SELECT @RootSupplierID = ManufacturingOrganizationID
FROM Product
WHERE ProductID = @RootProductID;

WITH ProductHierarchy AS (
    -- Anchor member: Start with the root product
    SELECT p.ProductID, p.Name AS ProductName, p.ManufacturingOrganizationID
    FROM Product p
    WHERE p.ProductID = @RootProductID

    UNION ALL

    -- Recursive member: Find all child parts in the hierarchy
    SELECT c.ProductID, c.Name AS ProductName, c.ManufacturingOrganizationID
    FROM ProductHierarchy ph
    JOIN BomItems b ON ph.ProductID = b.ParentProductID
    JOIN Product c ON b.ProductID = c.ProductID
)

-- Select only distinct suppliers excluding the root product's supplier
SELECT DISTINCT o.OrganizationID, o.Name AS SupplierName
FROM ProductHierarchy ph
JOIN Organization o ON ph.ManufacturingOrganizationID = o.OrganizationID
WHERE o.OrganizationID <> @RootSupplierID
ORDER BY SupplierName;
