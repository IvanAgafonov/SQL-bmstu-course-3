-- Табличная функция
CREATE FUNCTION get_cakes()
RETURNS @res table
(
ID int,
Dish_name varchar(30), 
Number_servings tinyint, 
Fats_grams_per_100_grams float,
With_fruits bit,
Сooking_difficulty varchar(20) 
)
AS
BEGIN
	INSERT INTO @res (ID, Dish_name, Number_servings, Fats_grams_per_100_grams, With_fruits, Сooking_difficulty) 
	SELECT ID, Dish_name, Number_servings, Fats_grams_per_100_grams, With_fruits, Сooking_difficulty FROM cakes
	RETURN
END