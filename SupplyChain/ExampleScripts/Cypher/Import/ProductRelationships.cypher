:auto LOAD CSV WITH HEADERS FROM 'file:///relationships.csv' AS row
CALL {
    WITH row
    MATCH (start:Product {id: toInteger(row.StartID)})
    MATCH (end:Product {id: toInteger(row.EndID)})
    MERGE (start)-[:IS_PARENT]->(end)
} IN TRANSACTIONS OF 5000 ROWS;
