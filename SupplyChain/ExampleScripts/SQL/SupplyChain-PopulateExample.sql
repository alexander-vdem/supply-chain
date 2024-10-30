USE SupplyChain;
GO

-- Insert 4 organizations into the Organization table
INSERT INTO Organization (OrganizationID, Name, TaxNumber)
VALUES 
(1, 'Imaginary Electronics', '123456789'),
(2, 'Acme', '987654321'),
(3, 'Honest Inc', '555666777'),
(4, 'Spare Electronics Inc', '112233445');

-- Insert trade types into TradeType table if not already present
-- 1 for Manufacturer, 2 for Distributor
INSERT INTO TradeType (TradeTypeID, TradeTypeName) VALUES (1, 'Manufacturer');

INSERT INTO TradeType (TradeTypeID, TradeTypeName) VALUES (2, 'Distributor');

-- Assign trade types to organizations
INSERT INTO OrganizationTradeType (OrganizationID, OrganizationTradeTypeID)
VALUES 
(1, 1),   -- Imaginary Electronics as Manufacturer
(2, 1),   -- Acme as Manufacturer
(3, 1),   -- Honest Inc as Manufacturer
(4, 2);   -- Spare Electronics Inc as Distributor

-- Insert Products
-- Note: CatalogNumber and ManufacturingOrganizationID values are hypothetical and should be unique
INSERT INTO Product (ProductID, Name, CatalogNumber, ManufacturingOrganizationID)
VALUES
(1, 'Complex Computer', 'CC123', 1),           -- Imaginary Electronics
(2, 'Keyboard', 'KB123', 2),                   -- Acme
(3, 'Button', 'BTN123', 2),                    -- Acme
(4, 'Keyboard Internal Body', 'KIB123', 2),    -- Acme
(5, 'Keys Circuit Board', 'KCB123', 2),        -- Acme
(6, 'Key Switch', 'KS123', 3),                 -- Honest Inc
(7, 'Simple Computer', 'SC123', 2),            -- Acme
(8, 'RAM', 'RAM123', 2),                       -- Acme
(9, 'Transistor', 'TR123', 3),                 -- Honest Inc
(10, 'Capacitor', 'CAP123', 2),                -- Acme
(11, 'Hard Drive', 'HD123', 2),                -- Acme
(12, 'Magnetic Disk', 'MD123', 3),             -- Honest Inc
(13, 'Hard Electronic Component', 'HEC123', 2),-- Acme
(14, 'Hard Drive Circuit Board', 'HDCB123', 2),-- Acme
(15, 'Resistor', 'RES123', 2),                 -- Acme
(16, 'Diode', 'DIO123', 3),                    -- Honest Inc
(17, 'Transistor Spare', 'TRSP123', 4),        -- Spare Electronics Inc
(18, 'Resistor Spare', 'RESSP123', 4);         -- Spare Electronics Inc

-- Insert BOMs (Bill of Materials) into ProductBom
INSERT INTO ProductBom (BomID, ProductID, BomVersion)
VALUES 
(1, 1, 1),   -- Complex Computer BOM
(2, 7, 1),   -- Simple Computer BOM
(3, 11, 1);  -- Hard Drive BOM

-- Insert BOM Items into BomItems to define the hierarchy
INSERT INTO BomItems (BomID, ProductID, ParentProductID, SubstituteProductID)
VALUES
-- Complex Computer BOM
(1, 2, 1, NULL),   -- Keyboard --->Complex Computer
(1, 7, 1, NULL),   -- Simple Computer --->Complex Computer

-- Keyboard BOM Items
(1, 3, 2, NULL),   -- Button --->Keyboard
(1, 4, 2, NULL),   -- Keyboard Internal Body --->Keyboard

-- Keyboard Internal Body BOM Items
(1, 5, 4, NULL),   -- Keys Circuit Board --->Keyboard Internal Body

-- Keys Circuit Board BOM Items
(1, 6, 5, NULL),   -- Key Switch --->Keys Circuit Board

-- Simple Computer BOM
(2, 8, 7, NULL),   -- RAM --->Simple Computer
(2, 11, 7, NULL),  -- Hard Drive --->Simple Computer

-- RAM BOM Items
(2, 9, 8, 17),   -- Transistor --->RAM, with Transistor Spare as alternative
(2, 10, 8, NULL),  -- Capacitor --->RAM

-- Hard Drive BOM
(3, 12, 11, NULL), -- Magnetic Disk --->Hard Drive
(3, 13, 11, NULL), -- Hard Electronic Component --->Hard Drive

-- Hard Electronic Component BOM Items
(3, 14, 13, NULL), -- Hard Drive Circuit Board --->Hard Electronic Component

-- Hard Drive Circuit Board BOM Items
(3, 15, 14, 18), -- Resistor --->Hard Drive Circuit Board, with Resistor Spare as alternative
(3, 16, 14, NULL), -- Diode --->Hard Drive Circuit Board

-- Add alternative sourcing for Transistor and Resistor
(2, 17, 8, 9), -- BOM 2, Product Transistor Spare (ProductID 17), Substitute Transistor (ProductID 9)
(3, 18, 14, 15); -- BOM 3, Product Resistor Spare (ProductID 18), Substitute Resistor (ProductID 15)
