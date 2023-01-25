CREATE LOGIN administrator WITH PASSWORD = N'adminPASS1234', DEFAULT_DATABASE = bookAndNewspaperPublisher;
GO

CREATE LOGIN storekeeper WITH PASSWORD = N'storePASS1234', DEFAULT_DATABASE = bookAndNewspaperPublisher;
GO

CREATE LOGIN production WITH PASSWORD = N'prodPASS1234', DEFAULT_DATABASE = bookAndNewspaperPublisher;
GO

USE bookAndNewspaperPublisher;
GO

CREATE USER administrator FOR LOGIN administrator WITH DEFAULT_SCHEMA = [employees];
GO

CREATE USER storekeeper FOR LOGIN storekeeper WITH DEFAULT_SCHEMA = [trading];
GO

CREATE USER production FOR LOGIN production WITH DEFAULT_SCHEMA = [production];
GO

ALTER ROLE db_datawriter ADD MEMBER administrator;
GO

GRANT INSERT, SELECT, UPDATE ON trading.warehouse TO storekeeper;
GO

GRANT INSERT, SELECT, UPDATE ON SCHEMA :: production TO production;
GO