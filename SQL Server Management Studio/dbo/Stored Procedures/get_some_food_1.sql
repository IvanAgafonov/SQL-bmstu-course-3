CREATE PROCEDURE get_some_food 
AS	
BEGIN
	DECLARE @n integer = 0
	SET @n = CAST(RAND()*10 AS int)
	PRINT @n
	
	SELECT TOP (@n) *
	FROM breakfast 
END