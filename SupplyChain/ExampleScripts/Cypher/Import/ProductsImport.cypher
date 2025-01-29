:auto LOAD CSV WITH HEADERS FROM 'file:///products.csv' AS line
CALL {
    WITH line
    MERGE (p:Product {id: toInteger(line.ProductID)})
    ON CREATE SET p.name = line.Name, p.category = line.CatalogNumber
} IN TRANSACTIONS OF 5000 ROWS;