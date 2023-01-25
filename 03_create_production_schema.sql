USE bookAndNewspaperPublisher;
GO

CREATE SCHEMA production;
GO

CREATE TABLE production.products (
	productID INT IDENTITY PRIMARY KEY,
	title NVARCHAR(50) UNIQUE,
	ISBN NVARCHAR(13) UNIQUE,
	genre NVARCHAR(20),
	spread SMALLINT,
	plannedPublicationDate DATE,
	releaseDate DATE,
	retailPrice INT
);

CREATE TABLE production.articles (
	productID INT FOREIGN KEY REFERENCES production.products(productID),
	articleID INT IDENTITY PRIMARY KEY,
	title NVARCHAR(50) UNIQUE,
	spread TINYINT,
	editor INT FOREIGN KEY REFERENCES employees.employees(employeeID),
	illustrator INT FOREIGN KEY REFERENCES employees.employees(employeeID),
	layoutEditor INT FOREIGN KEY REFERENCES employees.employees(employeeID),
	corrector INT FOREIGN KEY REFERENCES employees.employees(employeeID),
	editingWorkHours SMALLINT,
	illustrationWorkHours SMALLINT,
	layoutEditingWorkHours SMALLINT,
	correctionWorkHours SMALLINT
);

CREATE TABLE production.books (
	productID INT FOREIGN KEY REFERENCES production.products(productID),
	editor INT FOREIGN KEY REFERENCES employees.employees(employeeID),
	illustrator INT FOREIGN KEY REFERENCES employees.employees(employeeID),
	layoutEditor INT FOREIGN KEY REFERENCES employees.employees(employeeID),
	corrector INT FOREIGN KEY REFERENCES employees.employees(employeeID),
	editingWorkHours SMALLINT,
	illustrationWorkHours SMALLINT,
	layoutEditingWorkHours SMALLINT,
	correctionWorkHours SMALLINT
);