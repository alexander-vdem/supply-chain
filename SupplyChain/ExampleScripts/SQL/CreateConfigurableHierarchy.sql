USE SupplyChain;
GO

DECLARE @Depth INT = 5;  -- The number of levels in the hierarchy
DECLARE @ChildrenPerNode INT = 5;  -- The number of children each node should have
DECLARE @RootProductID INT = (SELECT ISNULL(MAX(ProductID), 0) + 1 FROM Product);  -- Set ProductID to be the next one after the last created product in the DB

-- Temporary table to hold products for each level
IF OBJECT_ID('tempdb..#TempProducts') IS NOT NULL
    DROP TABLE #TempProducts;

CREATE TABLE #TempProducts (
    Level INT,
    ParentProductID INT,
    ProductID INT
);

-- Insert the root product as the first level
INSERT INTO Product (ProductID, Name, CatalogNumber, ManufacturingOrganizationID)
VALUES (@RootProductID, 'RootProduct', 'PROD' + CAST(@RootProductID AS NVARCHAR), 1);

INSERT INTO #TempProducts (Level, ParentProductID, ProductID)
VALUES (1, NULL, @RootProductID);

DECLARE @CurrentLevel INT = 1;
DECLARE @NextProductID INT = (SELECT ISNULL(MAX(ProductID), 0) + 1 FROM Product);  -- Ensure unique ProductID starting from max existing ID
DECLARE @NextBomID INT = (SELECT ISNULL(MAX(BomID), 0) + 1 FROM ProductBom);  -- Ensure unique BomID starting from max existing ID

-- Insert a new BOM for the root product
INSERT INTO ProductBom (BomID, ProductID, BomVersion)
VALUES (@NextBomID, @RootProductID, 1);

-- Loop through each level and add children
WHILE @CurrentLevel < @Depth
BEGIN
    DECLARE @ParentProductID INT;

    DECLARE ProductCursor CURSOR FOR
    SELECT ProductID
    FROM #TempProducts
    WHERE Level = @CurrentLevel;

    OPEN ProductCursor;
    FETCH NEXT FROM ProductCursor INTO @ParentProductID;

    WHILE @@FETCH_STATUS = 0
    BEGIN
        DECLARE @i INT = 1;
        WHILE @i <= @ChildrenPerNode
        BEGIN
            -- Insert new product into Product table
            INSERT INTO Product (ProductID, Name, CatalogNumber, ManufacturingOrganizationID)
            VALUES (@NextProductID, CONCAT('Product_Level', @CurrentLevel + 1, '_Node', @i, '_Parent', @ParentProductID), CONCAT('CAT', @NextProductID), 1);

            -- Insert a new BOM for the child product
            SET @NextBomID = @NextBomID + 1;
            INSERT INTO ProductBom (BomID, ProductID, BomVersion)
            VALUES (@NextBomID, @NextProductID, 1);

            -- Insert BOM item for the parent-child relationship
            INSERT INTO BomItems (BomID, ProductID, ParentProductID)
            VALUES (@NextBomID, @NextProductID, @ParentProductID);

            -- Add new product to the temp table
            INSERT INTO #TempProducts (Level, ParentProductID, ProductID)
            VALUES (@CurrentLevel + 1, @ParentProductID, @NextProductID);

            SET @NextProductID = @NextProductID + 1;
            SET @i = @i + 1;
        END

        FETCH NEXT FROM ProductCursor INTO @ParentProductID;
    END

    CLOSE ProductCursor;
    DEALLOCATE ProductCursor;

    SET @CurrentLevel = @CurrentLevel + 1;
END

-- Display the generated hierarchy
SELECT *
FROM #TempProducts
ORDER BY Level, ParentProductID, ProductID;

-- Clean up temp table
DROP TABLE #TempProducts;
GO
