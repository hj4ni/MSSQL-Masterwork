USE bookAndNewspaperPublisher;
GO

CREATE SCHEMA trading;
GO

CREATE TABLE trading.customers (
	customerID INT IDENTITY PRIMARY KEY,
	customerName NVARCHAR(50) NOT NULL,
	registrationDate DATE NOT NULL,
	customerPostalID SMALLINT NOT NULL,
	customerCity NVARCHAR(20) NOT NULL,
	customerAddress NVARCHAR(50) NOT NULL,
	shippingPostalID SMALLINT NOT NULL,
	shippingCity NVARCHAR(20) NOT NULL,
	shippingAddress NVARCHAR(50) NOT NULL,
	emailAddress NVARCHAR(255),
	phoneNumber DEC(9,0) NOT NULL,
	contactPersonLastName NVARCHAR(20),
	contactPersonFirstName NVARCHAR(20)	
);

CREATE TABLE trading.orders (
	orderID INT IDENTITY PRIMARY KEY,
	customerID INT FOREIGN KEY REFERENCES trading.customers(customerID),
	productID INT FOREIGN KEY REFERENCES production.products(productID),
	unitPrice SMALLINT,
	taxRate TINYINT,
	orderedQuantity INT NOT NULL,
	orderDate DATE NOT NULL,
	orderPickupDate DATE,
	estimatedDeliveryDate DATE,
	comments NVARCHAR(MAX)
);

CREATE TABLE trading.warehouse (
	warehouseID INT IDENTITY PRIMARY KEY,
	productID INT FOREIGN KEY REFERENCES production.products(productID),
	stockQuantity INT NOT NULL,
	quantityPerPackage INT NOT NULL,
	stockingStartDate DATE DEFAULT CURRENT_TIMESTAMP,
	lastEditDate DATE DEFAULT CURRENT_TIMESTAMP,
	editedBy INT FOREIGN KEY REFERENCES employees.employees(employeeID),
	responsibleStorekeeper INT FOREIGN KEY REFERENCES employees.employees(employeeID),
	comment NVARCHAR(MAX)
);