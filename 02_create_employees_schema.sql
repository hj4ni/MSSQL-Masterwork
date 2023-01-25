USE bookAndNewspaperPublisher;
GO

CREATE SCHEMA employees;
GO

CREATE TABLE employees.employees (
	employeeID INT IDENTITY PRIMARY KEY,
	firstName NVARCHAR(20) NOT NULL,
	lastName NVARCHAR(20) NOT NULL,
	birthDay DATE NOT NULL,
	numberOfChildren TINYINT NOT NULL,
	socialSecurityIdentifier DEC(9,0) UNIQUE NOT NULL,
	taxIdentifier DEC(11,0) UNIQUE NOT NULL
);

CREATE TABLE employees.employment (
	employeeID INT FOREIGN KEY REFERENCES employees.employees(employeeID) UNIQUE,
	jobTitle NVARCHAR(20) NOT NULL,
	fullTime BIT,
	partTimeSix BIT,
	partTimeFour BIT,
	partTimeTwo BIT,
	maxWorkhoursPerMonth TINYINT NOT NULL
);

CREATE TABLE employees.annualLeave (
	employeeID INT FOREIGN KEY REFERENCES employees.employees(employeeID),
	leaveBegin DATE,
	leaveEnd DATE,
	annualLeave TINYINT,
	leaveTaken TINYINT,
	leaveAvailable TINYINT
);