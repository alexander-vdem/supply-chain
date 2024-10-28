-- Table: Person
CREATE TABLE Person (
    PersonID INT PRIMARY KEY,  -- Primary Key
    FirstName NVARCHAR(255) NOT NULL,  -- Unicode string for first name
    LastName NVARCHAR(255) NOT NULL,  -- Unicode string for last name
    Handle NVARCHAR(255)  -- Unicode string for handle/username
);

-- Table: Employer
CREATE TABLE Employer (
    EmployerID INT PRIMARY KEY,  -- Primary Key
    OrganizationName NVARCHAR(255) NOT NULL,  -- Unicode string for organization name
    FoundingDate DATE  -- Date type for founding date
);

-- Table: Employee
CREATE TABLE Employee (
    ContractID INT IDENTITY(1,1) PRIMARY KEY,  -- Auto-incremented primary key
    PersonID INT NOT NULL,  -- Foreign Key
    EmployerID INT NOT NULL,  -- Foreign Key
    IsCurrent BIT NOT NULL,  -- Boolean type for current status (1/0)
    Employee_Since DATE,  -- Date type for employment start date
    CONSTRAINT FK_Employee_Person FOREIGN KEY (PersonID) REFERENCES Person(PersonID),
    CONSTRAINT FK_Employee_Employer FOREIGN KEY (EmployerID) REFERENCES Employer(EmployerID)
);

-- Table: Connections
CREATE TABLE Connections (
    FollowerID INT NOT NULL,  -- Foreign Key
    FolloweeID INT NOT NULL,  -- Foreign Key
    CONSTRAINT FK_Connections_Follower FOREIGN KEY (FollowerID) REFERENCES Person(PersonID),
    CONSTRAINT FK_Connections_Followee FOREIGN KEY (FolloweeID) REFERENCES Person(PersonID),
    PRIMARY KEY (FollowerID, FolloweeID)  -- Composite Primary Key
);

-- Table: Post
CREATE TABLE Post (
    PostID INT PRIMARY KEY,  -- Primary Key
    PostContent NVARCHAR(MAX)  -- Unicode string for post content (large text)
);

-- Table: PersonPosts
CREATE TABLE PersonPosts (
    PostID INT NOT NULL,  -- Foreign Key
    PersonID INT NOT NULL,  -- Foreign Key
    CONSTRAINT FK_PersonPosts_Post FOREIGN KEY (PostID) REFERENCES Post(PostID),
    CONSTRAINT FK_PersonPosts_Person FOREIGN KEY (PersonID) REFERENCES Person(PersonID),
    PRIMARY KEY (PostID, PersonID)  -- Composite Primary Key
);

-- Table: EmployerPosts
CREATE TABLE EmployerPosts (
    EmployerID INT NOT NULL,  -- Foreign Key
    PostID INT NOT NULL,  -- Foreign Key
    CONSTRAINT FK_EmployerPosts_Employer FOREIGN KEY (EmployerID) REFERENCES Employer(EmployerID),
    CONSTRAINT FK_EmployerPosts_Post FOREIGN KEY (PostID) REFERENCES Post(PostID),
    PRIMARY KEY (EmployerID, PostID)  -- Composite Primary Key
);