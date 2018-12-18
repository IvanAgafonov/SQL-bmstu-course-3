CREATE PROCEDURE rec_found_fac_1  @n int, @ft int = 0
AS	
BEGIN
	SET @n -= 1 
	
	IF @n > 0
	BEGIN
		IF @n % 2 = 0
		BEGIN
				SET @ft +=
				(SELECT TOP 1 Fast_carbs_grams_per_100_grams
				FROM drinks
				ORDER BY Fast_carbs_grams_per_100_grams DESC)
			PRINT 'even'
			EXECUTE rec_found_fac_1 @n, @ft
		END			 
		ELSE
		BEGIN
				SET @ft +=
				(SELECT TOP 1 Fast_carbs_grams_per_100_grams
				FROM drinks
				ORDER BY Fast_carbs_grams_per_100_grams ASC)
			PRINT 'odd'
			EXECUTE rec_found_fac_1 @n, @ft
		END
	END
	ELSE
	BEGIN
		PRINT @ft
	END


END