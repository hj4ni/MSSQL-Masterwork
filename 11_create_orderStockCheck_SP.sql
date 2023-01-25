USE bookAndNewspaperPublisher;
GO

CREATE PROCEDURE trading.orderStockCheck (
	@orderID INT
)
AS
BEGIN TRY
	IF (SELECT orderID FROM trading.orders WHERE orderID = @orderID) IS NULL
	THROW 50010, 'Invalid OrderID, please check your data!', 1;
	
	ELSE SELECT
			[TO].orderID,
			[TO].productID,
			[PP].title,
			[PP].ISBN,
			[PP].releaseDate,
			[TO].orderedQuantity,
			[TW].stockQuantity,
			(CASE 
				WHEN [TO].orderedQuantity > [TW].stockQuantity THEN 'Insufficient Stock'
				WHEN [TO].orderedQuantity <= [TW].stockQuantity THEN 'Available'
			 END) AS [Status]
		 FROM trading.orders AS [TO]
		 INNER JOIN trading.warehouse AS [TW]
		 ON [TO].productID = [TW].productID
		 INNER JOIN production.products AS [PP]
		 ON [TW].productID = [PP].productID
		 WHERE [TO].orderID = @orderID;
END TRY

BEGIN CATCH
	SELECT
		ERROR_NUMBER() AS ErrorNumber,
		ERROR_SEVERITY() AS ErrorSeverity,
		ERROR_STATE() AS ErrorState,
		ERROR_PROCEDURE() AS ErrorProcedure,
		ERROR_MESSAGE() AS ErrorMessage 
END CATCH;