-- Create the database
CREATE DATABASE SocialNetwork;

-- Use the database
USE SocialNetwork;

-- Create the Employers table
CREATE TABLE Employers (
    EmployerID INT PRIMARY KEY IDENTITY(1,1),
    CompanyName NVARCHAR(100)
);

-- Create the People table
CREATE TABLE People (
    PersonID INT PRIMARY KEY IDENTITY(1,1),
    FirstName NVARCHAR(50),
    LastName NVARCHAR(50)
);

-- Create the Employee table to represent the relationship between People and Employers
CREATE TABLE Employee (
    PersonID INT,
    EmployerID INT,
    PRIMARY KEY (PersonID, EmployerID),
    FOREIGN KEY (PersonID) REFERENCES People(PersonID),
    FOREIGN KEY (EmployerID) REFERENCES Employers(EmployerID)
);

-- Create the Connections table
CREATE TABLE Connections (
    FollowerID INT,
    FolloweeID INT,
    PRIMARY KEY (FollowerID, FolloweeID),
    FOREIGN KEY (FollowerID) REFERENCES People(PersonID),
    FOREIGN KEY (FolloweeID) REFERENCES People(PersonID)
);

-- Insert data into Employers table
INSERT INTO Employers (CompanyName) VALUES ('Acme Corp');
INSERT INTO Employers (CompanyName) VALUES ('Globex Inc');
INSERT INTO Employers (CompanyName) VALUES ('Initech');

-- Insert data into People table
INSERT INTO People (FirstName, LastName) VALUES ('John', 'Doe');
INSERT INTO People (FirstName, LastName) VALUES ('Jane', 'Smith');
INSERT INTO People (FirstName, LastName) VALUES ('Alice', 'Johnson');
INSERT INTO People (FirstName, LastName) VALUES ('Bob', 'Brown');
INSERT INTO People (FirstName, LastName) VALUES ('Charlie', 'Davis');
INSERT INTO People (FirstName, LastName) VALUES ('Diana', 'Miller');
INSERT INTO People (FirstName, LastName) VALUES ('Eve', 'Wilson');
INSERT INTO People (FirstName, LastName) VALUES ('Frank', 'Moore');
INSERT INTO People (FirstName, LastName) VALUES ('Grace', 'Taylor');
INSERT INTO People (FirstName, LastName) VALUES ('Hank', 'Anderson');

-- Insert data into Employee table
INSERT INTO Employee (PersonID, EmployerID) VALUES (1, 1); -- John works for Acme Corp
INSERT INTO Employee (PersonID, EmployerID) VALUES (2, 1); -- Jane works for Acme Corp
INSERT INTO Employee (PersonID, EmployerID) VALUES (3, 2); -- Alice works for Globex Inc
INSERT INTO Employee (PersonID, EmployerID) VALUES (4, 2); -- Bob works for Globex Inc
INSERT INTO Employee (PersonID, EmployerID) VALUES (5, 3); -- Charlie works for Initech
INSERT INTO Employee (PersonID, EmployerID) VALUES (6, 3); -- Diana works for Initech
INSERT INTO Employee (PersonID, EmployerID) VALUES (7, 1); -- Eve works for Acme Corp
INSERT INTO Employee (PersonID, EmployerID) VALUES (8, 2); -- Frank works for Globex Inc
INSERT INTO Employee (PersonID, EmployerID) VALUES (9, 3); -- Grace works for Initech
INSERT INTO Employee (PersonID, EmployerID) VALUES (10, 1); -- Hank works for Acme Corp

-- Insert data into Connections table
INSERT INTO Connections (FollowerID, FolloweeID) VALUES (1, 2); -- John follows Jane
INSERT INTO Connections (FollowerID, FolloweeID) VALUES (2, 3); -- Jane follows Alice
INSERT INTO Connections (FollowerID, FolloweeID) VALUES (3, 4); -- Alice follows Bob
INSERT INTO Connections (FollowerID, FolloweeID) VALUES (4, 5); -- Bob follows Charlie
INSERT INTO Connections (FollowerID, FolloweeID) VALUES (5, 6); -- Charlie follows Diana
INSERT INTO Connections (FollowerID, FolloweeID) VALUES (6, 7); -- Diana follows Eve
INSERT INTO Connections (FollowerID, FolloweeID) VALUES (7, 8); -- Eve follows Frank
INSERT INTO Connections (FollowerID, FolloweeID) VALUES (8, 9); -- Frank follows Grace
INSERT INTO Connections (FollowerID, FolloweeID) VALUES (9, 10); -- Grace follows Hank
INSERT INTO Connections (FollowerID, FolloweeID) VALUES (10, 1); -- Hank follows John

DECLARE @CompanyName NVARCHAR(100) = 'Acme Corp'; -- Company name

SELECT DISTINCT p2.*
FROM Connections f1
JOIN Connections f2 ON f1.FolloweeID = f2.FollowerID
JOIN People p2 ON f2.FolloweeID = p2.PersonID
JOIN Employee e ON p2.PersonID = e.PersonID
JOIN Employers em ON e.EmployerID = em.EmployerID
WHERE em.CompanyName = @CompanyName;