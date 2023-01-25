USE bookAndNewspaperPublisher;
GO

DROP FUNCTION IF EXISTS employees.calcAnnualLeave;
GO

CREATE FUNCTION employees.calcAnnualLeave(@employeeID INT)
RETURNS TINYINT
AS
BEGIN
	DECLARE @return TINYINT;
	SELECT @return = (20 + (CASE WHEN DATEDIFF(YEAR, birthDay, GETDATE()) >= 25 THEN 1
								 WHEN DATEDIFF(YEAR, birthDay, GETDATE()) >= 28 THEN 2
								 WHEN DATEDIFF(YEAR, birthDay, GETDATE()) >= 31 THEN 3
								 WHEN DATEDIFF(YEAR, birthDay, GETDATE()) >= 33 THEN 4
								 WHEN DATEDIFF(YEAR, birthDay, GETDATE()) >= 35 THEN 5
								 WHEN DATEDIFF(YEAR, birthDay, GETDATE()) >= 37 THEN 6
								 WHEN DATEDIFF(YEAR, birthDay, GETDATE()) >= 39 THEN 7
								 WHEN DATEDIFF(YEAR, birthDay, GETDATE()) >= 41 THEN 8
								 WHEN DATEDIFF(YEAR, birthDay, GETDATE()) >= 43 THEN 9
								 WHEN DATEDIFF(YEAR, birthDay, GETDATE()) >= 45 THEN 10
							 END)
						 + (CASE WHEN numberOfChildren = 0 THEN 0
								 WHEN numberOfChildren = 1 THEN 2
 							     WHEN numberOfChildren = 2 THEN 4
								 WHEN numberOfChildren > 2 THEN 7
							END))
	FROM employees.employees
	WHERE employeeID = @employeeID
	RETURN @return
END;