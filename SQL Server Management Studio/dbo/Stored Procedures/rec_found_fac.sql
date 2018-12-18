CREATE PROCEDURE rec_found_fac  @n int 
AS	
BEGIN
	SET @n -= 1 

	IF @n > 0
	BEGIN
		IF @n % 2 = 0
		BEGIN
			EXECUTE rec_found_fac @n
			--UNION
			--SELECT TOP 1 *
			--FROM drinks
			--ORDER BY Fast_carbs_grams_per_100_grams DESC
			PRINT 'even'
		END			 
		ELSE
		BEGIN
			EXECUTE rec_found_fac @n
			--UNION
			--SELECT TOP 1 *
			--FROM drinks
			--ORDER BY Fast_carbs_grams_per_100_grams ASC
			PRINT 'odd'
		END
	END


END