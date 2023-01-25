USE bookAndNewspaperPublisher;
GO

EXECUTE employees.addEmployee
	@firstName = 'James',
	@lastName = 'Holden',
	@birthDay = '1975-05-10',
	@numberOfChildren = 2,
    @socialSecurityIdentifier = 154545612,
	@taxIdentifier = 12345678911;
GO

EXECUTE employees.addEmployment
	@employeeID = 1,
	@jobTitle = 'administrator',
	@fullTime = 1,
	@partTimeSix = 0,
	@partTimeFour = 0,
	@partTimeTwo = 0;
GO

EXECUTE employees.addAnnualLeave
	@employeeID = 1,
	@leaveBegin = '2021-05-31',
	@leaveEnd = '2021-06-13',
	@leaveTaken = 10
GO

EXECUTE employees.addEmployee
	@firstName = 'Jill',
	@lastName = 'Valentine',
	@birthDay = '1985-09-15',
	@numberOfChildren = 1,
    @socialSecurityIdentifier = 154545622,
	@taxIdentifier = 12345678921;
GO

EXECUTE employees.addEmployment
	@employeeID = 2,
	@jobtitle = 'corrector',
	@fullTime = 1,
	@partTimeSix = 0,
	@partTimeFour = 0,
	@partTimeTwo = 0;
GO

EXECUTE employees.addAnnualLeave
	@employeeID = 2,
	@leaveBegin = '2021-06-14',
	@leaveEnd = '2021-06-20',
	@leaveTaken = 5
GO

EXECUTE employees.addEmployee
	@firstName = 'Clare',
	@lastName = 'Redfield',
	@birthDay = '1987-10-05',
	@numberOfChildren = 0,
    @socialSecurityIdentifier = 154545623,
	@taxIdentifier = 12345678922;
GO

EXECUTE employees.addEmployment
	@employeeID = 3,
	@jobTitle = 'editor',
	@fullTime = 1,
	@partTimeSix = 0,
	@partTimeFour = 0,
	@partTimeTwo = 0;
GO

EXECUTE employees.addAnnualLeave
	@employeeID = 3,
	@leaveBegin = '2021-06-21',
	@leaveEnd = '2021-06-27',
	@leaveTaken = 5
GO

EXECUTE employees.addEmployee
	@firstName = 'John',
	@lastName = 'Winchester',
	@birthDay = '1977-03-25',
	@numberOfChildren = 3,
    @socialSecurityIdentifier = 154545626,
	@taxIdentifier = 12345678929;
GO

EXECUTE employees.addEmployment
	@employeeID = 4,
	@jobTitle = 'illustrator',
	@fullTime = 1,
	@partTimeSix = 0,
	@partTimeFour = 0,
	@partTimeTwo = 0;
GO

EXECUTE employees.addAnnualLeave
	@employeeID = 4,
	@leaveBegin = '2021-06-28',
	@leaveEnd = '2021-07-04',
	@leaveTaken = 5
GO

EXECUTE employees.addEmployee
	@firstName = 'Michael',
	@lastName = 'Sullivan',
	@birthDay = '1969-12-11',
	@numberOfChildren = 2,
    @socialSecurityIdentifier = 154545627,
	@taxIdentifier = 12345678927;
GO

EXECUTE employees.addEmployment
	@employeeID = 5,
	@jobTitle = 'layoutEditor',
	@fullTime = 1,
	@partTimeSix = 0,
	@partTimeFour = 0,
	@partTimeTwo = 0;
GO

EXECUTE employees.addAnnualLeave
	@employeeID = 5,
	@leaveBegin = '2021-07-05',
	@leaveEnd = '2021-07-11',
	@leaveTaken = 5
GO

EXECUTE employees.addEmployee
	@firstName = 'Diane',
	@lastName = 'Margheim',
	@birthDay = '1990-02-27',
	@numberOfChildren = 0,
    @socialSecurityIdentifier = 154545625,
	@taxIdentifier = 12345678923;
GO

EXECUTE employees.addEmployment
	@employeeID = 6,
	@jobTitle = 'storekeeper',
	@fullTime = 1,
	@partTimeSix = 0,
	@partTimeFour = 0,
	@partTimeTwo = 0;
GO

EXECUTE employees.addAnnualLeave
	@employeeID = 6,
	@leaveBegin = '2021-07-12',
	@leaveEnd = '2021-07-25',
	@leaveTaken = 10
GO

INSERT INTO production.products (title, ISBN, genre, spread, plannedPublicationDate, releaseDate, retailPrice)
VALUES ('Expanse 9', 1234567890123, 'sci-fi', 500, '2020-09-01', '2021-01-01', 3500),
	   ('Daily Planet', 123456789124, 'newspaper', 50, '2021-08-05', '2021-08-05', 500),
	   ('The Witcher', 123456789125, 'fantasy', 350, '2010-07-01', '2011-09-01', 3000),
	   ('Game of Thrones', 123456789126, 'fantasy', 694, '1995-01-01', '1996-08-01', 2500),
	   ('Daily Bugle', 123456789127, 'newspaper', 50, '2021-08-01', '2021-08-01', 1500);

INSERT INTO production.books (productID, editor, illustrator, layoutEditor, corrector,
							  editingWorkHours, illustrationWorkHours, layoutEditingWorkHours, correctionWorkHours)
VALUES (1, 3, 4, 5, 2, 360, 180, 180, 90),
	   (3, 3, 4, 5, 2, 280, 230, 200, 70),
	   (4, 3, 4, 5, 2, 400, 100, 90, 110);

INSERT INTO production.articles (productID, title, spread, editor, illustrator, layoutEditor, corrector,
							  editingWorkHours, illustrationWorkHours, layoutEditingWorkHours, correctionWorkHours)
VALUES (2, 'Pollution', 4, 3, 4, 5, 2, 4, 2, 2, 1),
	   (2, 'Public transport Or Bike?', 2, 3, 4, 5, 2, 2, 1, 1, 1),
	   (5, 'Who is Spiderman?', 2, 3, 4, 5, 2, 2, 2, 2, 2);

INSERT INTO trading.customers (customerName, registrationDate, customerPostalID, customerCity, customerAddress, shippingPostalID, shippingCity, shippingAddress, emailAddress, phoneNumber, contactPersonLastName, contactPersonFirstName)
VALUES ('Ebru Industries', '2015-01-01', 24805, 'Baruaville', '548 Bures Crescent', 18110, 'Kamasamudramville', '1432 Alksne Road', 'ebru@industries.com', 012345678, 'Ebru', 'Erdogan'),
  	   ('Ivan Industries', '2016-04-01', 4977, 'Hopkinsville', '1505 Stojkovic Street', 4977, 'Hopkinsville', '1505 Stojkovic Street', 'ivan@industries.com', 012345679, 'Ivan', 'Sepulveda'),
	   ('Matyas Industries', '2013-07-01', 13868, 'Henzlville', '1129 Hulsegge Boulevard', 13868, 'Henzlville', '1129 Hulsegge Boulevard', 'matyas@industries.com', 012345670, 'Matyas', 'Sedlar'),
	   ('Juan Industries', '2017-02-01', 31009, 'Dinhville', '802 Mokkapati Road6', 31009, 'Dinhville', '802 Mokkapati Road6', 'juan@industries.com', 012345672, 'Juan', 'Morse'),
	   ('Victoria Industries', '2020-08-01', 7408, 'Siavashiville', '622 Pavel Boulevard', 7408, 'Siavashiville', '622 Pavel Boulevard', 'victoria@industries.com', 012345673, 'Victoria', 'Lacusta');

INSERT INTO trading.warehouse (productID, stockQuantity, quantityPerPackage, editedBy, responsibleStorekeeper)
VALUES (1, 2000, 5, 6, 6),
  	   (2, 10000, 20, 6, 6),
	   (3, 3000, 5, 6, 6),
	   (4, 5000, 5, 6, 6),
	   (5, 20000, 25, 6, 6);


INSERT INTO trading.orders (customerID, productID, unitPrice, taxRate, orderedQuantity, orderDate, orderPickupDate, estimatedDeliveryDate)
VALUES (1, 1, 3500, 10, 100, '2021-08-10', '2021-08-11', '2021-08-13'),
	   (2, 2, 500, 5, 10000, '2021-08-05', '2021-08-06', '2021-08-07'),
	   (3, 3, 3000, 10, 1000, '2021-06-05', '2021-06-07', '2021-06-10'),
	   (4, 4, 2500, 10, 1500, '2021-08-19', '2021-08-24', '2021-08-26');

INSERT INTO trading.orders (customerID, productID, unitPrice, taxRate, orderedQuantity, orderDate)
VALUES (5, 5, 1500, 5, 35000, '2021-07-25');