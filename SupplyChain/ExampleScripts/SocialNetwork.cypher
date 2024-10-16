// Create Employers
CREATE (acme:Employer {companyName: 'Acme Corp'}),
       (globex:Employer {companyName: 'Globex Inc'}),
       (initech:Employer {companyName: 'Initech'});

// Create People
CREATE (john:Person {firstName: 'John', lastName: 'Doe'}),
       (jane:Person {firstName: 'Jane', lastName: 'Smith'}),
       (alice:Person {firstName: 'Alice', lastName: 'Johnson'}),
       (bob:Person {firstName: 'Bob', lastName: 'Brown'}),
       (charlie:Person {firstName: 'Charlie', lastName: 'Davis'}),
       (diana:Person {firstName: 'Diana', lastName: 'Miller'}),
       (eve:Person {firstName: 'Eve', lastName: 'Wilson'}),
       (frank:Person {firstName: 'Frank', lastName: 'Moore'}),
       (grace:Person {firstName: 'Grace', lastName: 'Taylor'}),
       (hank:Person {firstName: 'Hank', lastName: 'Anderson'});

// Create WORKS_FOR relationships
MATCH (john:Person {firstName: 'John', lastName: 'Doe'}), (acme:Employer {companyName: 'Acme Corp'})
CREATE (john)-[:WORKS_FOR]->(acme);

MATCH (jane:Person {firstName: 'Jane', lastName: 'Smith'}), (acme:Employer {companyName: 'Acme Corp'})
CREATE (jane)-[:WORKS_FOR]->(acme);

MATCH (alice:Person {firstName: 'Alice', lastName: 'Johnson'}), (globex:Employer {companyName: 'Globex Inc'})
CREATE (alice)-[:WORKS_FOR]->(globex);

MATCH (bob:Person {firstName: 'Bob', lastName: 'Brown'}), (globex:Employer {companyName: 'Globex Inc'})
CREATE (bob)-[:WORKS_FOR]->(globex);

MATCH (charlie:Person {firstName: 'Charlie', lastName: 'Davis'}), (initech:Employer {companyName: 'Initech'})
CREATE (charlie)-[:WORKS_FOR]->(initech);

MATCH (diana:Person {firstName: 'Diana', lastName: 'Miller'}), (initech:Employer {companyName: 'Initech'})
CREATE (diana)-[:WORKS_FOR]->(initech);

MATCH (eve:Person {firstName: 'Eve', lastName: 'Wilson'}), (acme:Employer {companyName: 'Acme Corp'})
CREATE (eve)-[:WORKS_FOR]->(acme);

MATCH (frank:Person {firstName: 'Frank', lastName: 'Moore'}), (globex:Employer {companyName: 'Globex Inc'})
CREATE (frank)-[:WORKS_FOR]->(globex);

MATCH (grace:Person {firstName: 'Grace', lastName: 'Taylor'}), (initech:Employer {companyName: 'Initech'})
CREATE (grace)-[:WORKS_FOR]->(initech);

MATCH (hank:Person {firstName: 'Hank', lastName: 'Anderson'}), (acme:Employer {companyName: 'Acme Corp'})
CREATE (hank)-[:WORKS_FOR]->(acme);

// Create FOLLOWS relationships
MATCH (john:Person {firstName: 'John', lastName: 'Doe'}), (jane:Person {firstName: 'Jane', lastName: 'Smith'})
CREATE (john)-[:FOLLOWS]->(jane);

MATCH (jane:Person {firstName: 'Jane', lastName: 'Smith'}), (alice:Person {firstName: 'Alice', lastName: 'Johnson'})
CREATE (jane)-[:FOLLOWS]->(alice);

MATCH (alice:Person {firstName: 'Alice', lastName: 'Johnson'}), (bob:Person {firstName: 'Bob', lastName: 'Brown'})
CREATE (alice)-[:FOLLOWS]->(bob);

MATCH (bob:Person {firstName: 'Bob', lastName: 'Brown'}), (charlie:Person {firstName: 'Charlie', lastName: 'Davis'})
CREATE (bob)-[:FOLLOWS]->(charlie);

MATCH (charlie:Person {firstName: 'Charlie', lastName: 'Davis'}), (diana:Person {firstName: 'Diana', lastName: 'Miller'})
CREATE (charlie)-[:FOLLOWS]->(diana);

MATCH (diana:Person {firstName: 'Diana', lastName: 'Miller'}), (eve:Person {firstName: 'Eve', lastName: 'Wilson'})
CREATE (diana)-[:FOLLOWS]->(eve);

MATCH (eve:Person {firstName: 'Eve', lastName: 'Wilson'}), (frank:Person {firstName: 'Frank', lastName: 'Moore'})
CREATE (eve)-[:FOLLOWS]->(frank);

MATCH (frank:Person {firstName: 'Frank', lastName: 'Moore'}), (grace:Person {firstName: 'Grace', lastName: 'Taylor'})
CREATE (frank)-[:FOLLOWS]->(grace);

MATCH (grace:Person {firstName: 'Grace', lastName: 'Taylor'}), (hank:Person {firstName: 'Hank', lastName: 'Anderson'})
CREATE (grace)-[:FOLLOWS]->(hank);

MATCH (hank:Person {firstName: 'Hank', lastName: 'Anderson'}), (john:Person {firstName: 'John', lastName: 'Doe'})
CREATE (hank)-[:FOLLOWS]->(john);

// Query to find followers of followers who work for a particular company
MATCH (p1:Person)-[:FOLLOWS]->(p2:Person)-[:FOLLOWS]->(p3:Person)-[:WORKS_FOR]->(e:Employer {companyName: 'Acme Corp'})
RETURN DISTINCT p3;