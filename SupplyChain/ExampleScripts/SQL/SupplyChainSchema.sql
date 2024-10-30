IF NOT EXISTS (SELECT * FROM sys.databases WHERE name = 'SupplyChain')
BEGIN
    CREATE DATABASE [SupplyChain];
END;
GO

Use SupplyChain 
GO

IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'Product')
BEGIN
    CREATE TABLE Product (
        ProductID INT PRIMARY KEY,
        Name NVARCHAR(255) NOT NULL,
        CatalogNumber NVARCHAR(50) NOT NULL,
        ManufacturingOrganizationID INT NOT NULL,
        CONSTRAINT UQ_Product_CatalogNumber_ManufacturingOrganizationID UNIQUE (CatalogNumber, ManufacturingOrganizationID)
    );
END;


IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'Organization')
BEGIN
    CREATE TABLE Organization (
        OrganizationID INT PRIMARY KEY,
        Name NVARCHAR(255) NOT NULL,
        TaxNumber NVARCHAR(50) NOT NULL UNIQUE
    );
END;


IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'TradeType')
BEGIN
    CREATE TABLE TradeType (
        TradeTypeID INT PRIMARY KEY,
        TradeTypeName NVARCHAR(100) NOT NULL
    );
END;


IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'OrganizationTradeType')
BEGIN
    CREATE TABLE OrganizationTradeType (
        OrganizationID INT NOT NULL,
        OrganizationTradeTypeID INT NOT NULL,
        PRIMARY KEY (OrganizationID, OrganizationTradeTypeID),
        CONSTRAINT FK_OrganizationTradeType_Organization FOREIGN KEY (OrganizationID) REFERENCES Organization(OrganizationID),
        CONSTRAINT FK_OrganizationTradeType_TradeType FOREIGN KEY (OrganizationTradeTypeID) REFERENCES TradeType(TradeTypeID)
    );
END;

IF NOT EXISTS (
    SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_Product_Organization]')
)
BEGIN
    ALTER TABLE Product
    ADD CONSTRAINT FK_Product_Organization FOREIGN KEY (ManufacturingOrganizationID) REFERENCES Organization(OrganizationID);
END;


IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'ProductBom')
BEGIN
    CREATE TABLE ProductBom (
        BomID INT PRIMARY KEY,
        ProductID INT NOT NULL,
        BomVersion INT NOT NULL,
        CONSTRAINT FK_ProductBom_Product FOREIGN KEY (ProductID) REFERENCES Product(ProductID)
    );
END;


IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'BomItems')
BEGIN
    CREATE TABLE BomItems (
        BomID INT NOT NULL,
        ProductID INT NOT NULL,
        ParentProductID INT NOT NULL,
        SubstituteProductID INT NULL,
        PRIMARY KEY (BomID, ProductID),
        CONSTRAINT FK_BomItems_Product FOREIGN KEY (ProductID) REFERENCES Product(ProductID),
        CONSTRAINT FK_BomItems_ParentProduct FOREIGN KEY (ParentProductID) REFERENCES Product(ProductID),
        CONSTRAINT FK_BomItems_SubstituteProduct FOREIGN KEY (SubstituteProductID) REFERENCES Product(ProductID),
        CONSTRAINT FK_BomItems_Bom FOREIGN KEY (BomID) REFERENCES ProductBom(BomID)
    );
END;