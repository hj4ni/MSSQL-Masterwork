USE bookAndNewspaperPublisher;
GO

CREATE PROCEDURE employees.addEmployee (
	@firstName NVARCHAR(20),
	@lastName NVARCHAR(20),
	@birthDay DATE,
	@numberOfChildren TINYINT,
	@socialSecurityIdentifier DEC(9,0),
	@taxIdentifier DEC(11,0)
)
AS
BEGIN TRY
	IF @birthDay < '1900-01-01' OR @birthDay > GETDATE()
	THROW 50001, 'Invalid birth date, please add a date after 1900-01-01 and before today!', 1

	IF @numberOfChildren < 0
	THROW 50002, 'Invalid number, please add a valid number of children (0 or above)!', 1

	IF LEN(CAST(@socialSecurityIdentifier AS nvarchar)) != 9
	THROW 50003, 'Invalid social security identifier, please add a number with 9 digit lenght!', 1

	IF @socialSecurityIdentifier = (SELECT socialSecurityIdentifier FROM employees.employees WHERE socialSecurityIdentifier = @socialSecurityIdentifier)
	THROW 50004, 'This social security identifier is already in use, please review your data!', 2

	IF LEN(CAST(@taxIdentifier AS nvarchar)) != 11
	THROW 50005, 'Invalid tax identifier, please add a number with 11 digit lenght!', 1

	IF @taxIdentifier = (SELECT taxIdentifier FROM employees.employees WHERE taxIdentifier = @taxIdentifier)
	THROW 50006, 'This tax identifier is already in use, please review your data!', 2

INSERT INTO employees.employees (
	firstName,
	lastName,
	birthDay,
	numberOfChildren,
	socialSecurityIdentifier,
	taxIdentifier
) VALUES (
	@firstName,
	@lastName,
	@birthDay,
	@numberOfChildren,
	@socialSecurityIdentifier,
	@taxIdentifier
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