USE SupplyChain;
GO

DECLARE @TotalEntries INT = 10000000;

-- Temporarily drop foreign key constraints from BomItems table
ALTER TABLE BomItems NOCHECK CONSTRAINT FK_BomItems_Product;
ALTER TABLE BomItems NOCHECK CONSTRAINT FK_BomItems_ParentProduct;
ALTER TABLE BomItems NOCHECK CONSTRAINT FK_BomItems_SubstituteProduct;
ALTER TABLE BomItems NOCHECK CONSTRAINT FK_BomItems_Bom;
GO

-- Insert random data into BomItems to reach 2 million entries
DECLARE @CurrentEntries INT = (SELECT COUNT(*) FROM BomItems);
DECLARE @MaxBomID INT = (SELECT ISNULL(MAX(BomID), 0) FROM BomItems);
DECLARE @MaxProductID INT = (SELECT ISNULL(MAX(ProductID), 0) FROM BomItems);

WHILE @CurrentEntries < @TotalEntries
BEGIN
    INSERT INTO BomItems (BomID, ProductID, ParentProductID)
    SELECT TOP (10000) @MaxBomID + ROW_NUMBER() OVER (ORDER BY NEWID()),  -- Unique BomID
                   @MaxProductID + ROW_NUMBER() OVER (ORDER BY NEWID()),  -- Unique ProductID
                   ABS(CHECKSUM(NEWID())) % 100000 + 1  -- Random ParentProductID
    FROM sys.objects AS o1
    CROSS JOIN sys.objects AS o2;

    SET @MaxBomID = @MaxBomID + 10000;
    SET @MaxProductID = @MaxProductID + 10000;
    SET @CurrentEntries = (SELECT COUNT(*) FROM BomItems);
END

-- Re-enable foreign key constraints on BomItems table
ALTER TABLE BomItems CHECK CONSTRAINT FK_BomItems_Product;
ALTER TABLE BomItems CHECK CONSTRAINT FK_BomItems_ParentProduct;
ALTER TABLE BomItems CHECK CONSTRAINT FK_BomItems_SubstituteProduct;
ALTER TABLE BomItems CHECK CONSTRAINT FK_BomItems_Bom;