CREATE CONSTRAINT unique_supplier_taxNumber IF NOT EXISTS
FOR (s:Supplier)
REQUIRE s.taxNumber IS UNIQUE;

// Create Supplier nodes
MERGE (imaginaryElectronics:Supplier {organizationID: 1, name: 'Imaginary Electronics',
taxNumber: '123456789', organizationType: ['Manufacturer']})
MERGE  (acme:Supplier {organizationID: 2, name: 'Acme', 
taxNumber: '987654321', organizationType: ['Manufacturer']})
MERGE  (honestInc:Supplier {organizationID: 3, name: 'Honest Inc', 
taxNumber: '555666777', organizationType: ['Manufacturer']})
MERGE  (spareElectronicsInc:Supplier {organizationID: 4, name: 'Spare Electronics Inc',
 taxNumber: '112233445', organizationType: ['Distributor']})

// Create Product nodes
MERGE (complexComputer:Product 
{ProductID: 1, name: 'Complex Computer', catalogNumber: 'CC123'})
MERGE  (keyboard:Product {ProductID: 2, name: 'Keyboard', catalogNumber: 'KB123'})
MERGE  (button:Product {ProductID: 3, name: 'Button', catalogNumber: 'BTN123'})
MERGE  (keyboardInternalBody:Product {ProductID: 4, name: 'Keyboard Internal Body', 
catalogNumber: 'KIB123'})
MERGE  (keysCircuitBoard:Product {ProductID: 5, name: 'Keys Circuit Board',
 catalogNumber: 'KCB123'})
MERGE  (keySwitch:Product {ProductID: 6, name: 'Key Switch', catalogNumber: 'KS123'})
MERGE  (simpleComputer:Product {ProductID: 7, name: 'Simple Computer', 
catalogNumber: 'SC123'})
MERGE  (ram:Product {ProductID: 8, name: 'RAM', catalogNumber: 'RAM123'})
MERGE  (transistor:Product {ProductID: 9, name: 'Transistor', catalogNumber: 'TR123'})
MERGE  (capacitor:Product {ProductID: 10, name: 'Capacitor', catalogNumber: 'CAP123'})
MERGE  (hardDrive:Product {ProductID: 11, name: 'Hard Drive', catalogNumber: 'HD123'})
MERGE  (magneticDisk:Product {ProductID: 12, name: 'Magnetic Disk', 
catalogNumber: 'MD123'})
MERGE  (hardElectronicComponent:Product {ProductID: 13,
 name: 'Hard Electronic Component', catalogNumber: 'HEC123'})
MERGE  (hardDriveCircuitBoard:Product {ProductID: 14, name: 'Hard Drive Circuit Board',
catalogNumber: 'HDCB123'})
MERGE  (resistor:Product {ProductID: 15, name: 'Resistor', catalogNumber: 'RES123'})
MERGE  (diode:Product {ProductID: 16, name: 'Diode', catalogNumber: 'DIO123'})
MERGE  (transistorSpare:Product {ProductID: 17, name: 'Transistor Spare', 
catalogNumber: 'TRSP123'})
MERGE  (resistorSpare:Product {ProductID: 18, name: 'Resistor Spare', 
catalogNumber: 'RESSP123'})

// Create ProductBOM nodes with name property
MERGE (complexComputerBOM:ProductBOM {name: 'Complex Computer BOM',BomID: 1, bomVersion: 1})
MERGE (simpleComputerBOM:ProductBOM {name: 'Simple Computer BOM',BomID: 2, bomVersion: 1})
MERGE (hardDriveBOM:ProductBOM {name: 'Hard Drive BOM', BomID: 3, bomVersion: 1})

// Create DESCRIBES relationships from BOM to root product
MERGE (complexComputerBOM)-[:DESCRIBES]->(complexComputer)
MERGE (simpleComputerBOM)-[:DESCRIBES]->(simpleComputer)
MERGE (hardDriveBOM)-[:DESCRIBES]->(hardDrive)

// Create IS_PARENT relationships for the hierarchy
MERGE (complexComputer)-[:IS_PARENT]->(keyboard)
MERGE  (complexComputer)-[:IS_PARENT]->(simpleComputer)
MERGE  (keyboard)-[:IS_PARENT]->(button)
MERGE  (keyboard)-[:IS_PARENT]->(keyboardInternalBody)
MERGE  (keyboardInternalBody)-[:IS_PARENT]->(keysCircuitBoard)
MERGE  (keysCircuitBoard)-[:IS_PARENT]->(keySwitch)
MERGE  (simpleComputer)-[:IS_PARENT]->(ram)
MERGE  (simpleComputer)-[:IS_PARENT]->(hardDrive)
MERGE  (ram)-[:IS_PARENT]->(transistor)
MERGE  (ram)-[:IS_PARENT]->(capacitor)  
MERGE  (hardDrive)-[:IS_PARENT]->(magneticDisk)
MERGE  (hardDrive)-[:IS_PARENT]->(hardElectronicComponent)
MERGE  (hardElectronicComponent)-[:IS_PARENT]->(hardDriveCircuitBoard)
MERGE  (hardDriveCircuitBoard)-[:IS_PARENT]->(resistor)
MERGE  (hardDriveCircuitBoard)-[:IS_PARENT]->(diode)

// Create SUBSTITUTES relationships for spare parts
MERGE (transistor)-[:SUBSTITUTES]->(transistorSpare)
MERGE  (resistor)-[:SUBSTITUTES]->(resistorSpare)

// Create PRODUCES relationships for manufacturers
MERGE (imaginaryElectronics)-[:PRODUCES]->(complexComputer)
MERGE  (acme)-[:PRODUCES]->(keyboard)
MERGE  (acme)-[:PRODUCES]->(button)
MERGE  (acme)-[:PRODUCES]->(keyboardInternalBody)
MERGE  (acme)-[:PRODUCES]->(keysCircuitBoard)
MERGE  (honestInc)-[:PRODUCES]->(keySwitch) 
MERGE  (acme)-[:PRODUCES]->(simpleComputer)
MERGE  (acme)-[:PRODUCES]->(ram)
MERGE  (honestInc)-[:PRODUCES]->(transistor)
MERGE  (acme)-[:PRODUCES]->(capacitor) 
MERGE  (acme)-[:PRODUCES]->(hardDrive)
MERGE  (honestInc)-[:PRODUCES]->(magneticDisk)
MERGE  (acme)-[:PRODUCES]->(hardElectronicComponent)
MERGE  (acme)-[:PRODUCES]->(hardDriveCircuitBoard)
MERGE  (acme)-[:PRODUCES]->(resistor)
MERGE  (honestInc)-[:PRODUCES]->(diode)

// Create DISTRIBUTES relationships for distributors
MERGE (spareElectronicsInc)-[:DISTRIBUTES]->(transistorSpare)
MERGE  (spareElectronicsInc)-[:DISTRIBUTES]->(resistorSpare)
