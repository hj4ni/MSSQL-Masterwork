USE bookAndNewspaperPublisher;
GO

DROP TABLE IF EXISTS trading.warehouse_log;
GO

CREATE TABLE trading.warehouse_log (
	warehouseID INT FOREIGN KEY REFERENCES trading.warehouse(warehouseID),
	stockQuantity INT,
	quantityPerPackage INT,
	lastEditDate DATE DEFAULT CURRENT_TIMESTAMP,
	PRIMARY KEY (warehouseID, lastEditDate)
);

DROP TRIGGER IF EXISTS trading.warehouse_update;
GO

CREATE TRIGGER warehouse_update
ON trading.warehouse
AFTER UPDATE, INSERT, DELETE
AS  
INSERT INTO trading.warehouse_log (warehouseID, stockQuantity, quantityPerPackage)
       SELECT warehouseID, stockQuantity, quantityPerPackage FROM inserted;