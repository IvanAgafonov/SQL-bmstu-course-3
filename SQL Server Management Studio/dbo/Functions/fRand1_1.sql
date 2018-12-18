CREATE FUNCTION fRand1(@min int, @max int) 
RETURNS datetime 
BEGIN 
	DECLARE @k datetime = GETDATE()
	RETURN @k
END

