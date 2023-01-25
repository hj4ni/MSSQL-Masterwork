USE bookAndNewspaperPublisher;
GO

CREATE PROCEDURE employees.addAnnualLeave (
	@employeeID INT,
	@leaveBegin DATE,
	@leaveEnd DATE,
	@leaveTaken TINYINT
)
AS
BEGIN TRY
	IF @employeeID IS NULL
	OR (SELECT employeeID FROM employees.employees WHERE employeeID = @employeeID) IS NULL
	THROW 50009, 'Invalid EmployeeID, please review your data!', 1

	INSERT INTO employees.annualLeave (employeeID, leaveBegin, leaveEnd, annualLeave, leaveTaken, leaveAvailable)
	VALUES (
		@employeeID,
		@leaveBegin,
		@leaveEnd,
		employees.calcAnnualLeave(@employeeID),
		@leaveTaken,
		employees.calcAnnualLeave(@employeeID) - @leaveTaken
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