CREATE PROCEDURE get_some_drinks_from_food 
AS	
BEGIN
	DECLARE @n integer = 0
	DECLARE  @need_inf CURSOR 
	SET @n = CAST(RAND()*5 AS int)
	PRINT @n
	
	SET @need_inf = CURSOR SCROLL FOR
	SELECT TOP (@n) D.ID, D.Drink_name, D.Fast_carbs_grams_per_100_grams, D.Above_average_rating, D.Temperature_serving_C, D.Color
	FROM breakfast LEFT OUTER JOIN drinks AS D ON breakfast.ID_drinks = D.ID
	
	OPEN @need_inf
	
	WHILE @n > 0
	BEGIN
		FETCH NEXT FROM @need_inf
		SET @n -= 1
	END
	
	CLOSE @need_inf 
END