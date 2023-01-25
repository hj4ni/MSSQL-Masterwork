USE bookAndNewspaperPublisher;
GO

CREATE PROCEDURE employees.addEmployment (
	@employeeID INT,
	@jobTitle NVARCHAR(20),
	@fullTime BIT,
	@partTimeSix BIT,
	@partTimeFour BIT,
	@partTimeTwo BIT
)
AS
BEGIN TRY
	IF @employeeID IS NULL
	OR (SELECT employeeID FROM employees.employees WHERE employeeID = @employeeID) IS NULL
	OR (SELECT employeeID FROM employees.employment WHERE employeeID = @employeeID) IS NOT NULL
	THROW 50007, 'Invalid EmployeeID, please review your data!', 1

	IF @fullTime = 1 AND (@partTimeSix = 1 OR @partTimeFour = 1 OR @partTimeTwo = 1)
	THROW 50008, 'An employee can not work in multiple employment!', 2

	IF @partTimeSix = 1 AND (@fullTime = 1 OR @partTimeFour = 1 OR @partTimeTwo = 1)
	THROW 50008, 'An employee can not work in multiple employment!', 2

	IF @partTimeFour = 1 AND (@fullTime = 1 OR @partTimeSix = 1 OR @partTimeTwo = 1)
	THROW 50008, 'An employee can not work in multiple employment!', 2

	IF @partTimeTwo = 1 AND (@fullTime = 1 OR @partTimeSix = 1 OR @partTimeFour = 1)
	THROW 50008, 'An employee can not work in multiple employment!', 2

	INSERT INTO employees.employment (employeeID, jobTitle,	fullTime, partTimeSix, partTimeFour, partTimeTwo, maxWorkhoursPerMonth)
	VALUES (
		@employeeID,
		@jobTitle,
		@fullTime,
		@partTimeSix,
		@partTimeFour,
		@partTimeTwo,
		(CASE 
			 WHEN @fullTime = 1 THEN 180
			 WHEN @partTimeSix = 1 THEN 135
			 WHEN @partTimeFour = 1 THEN 90
			 WHEN @partTimeTwo = 1 THEN 45
		 END)
	)
END TRY

BEGIN CATCH
	SELECT
		ERROR_NUMBER() AS ErrorNumber,
		ERROR_SEVERITY() AS ErrorSeverity,
		ERROR_STATE() AS ErrorState,
		ERROR_PROCEDURE() AS ErrorProcedure,
		ERROR_MESSAGE() AS ErrorMessage 
END CATCH;
