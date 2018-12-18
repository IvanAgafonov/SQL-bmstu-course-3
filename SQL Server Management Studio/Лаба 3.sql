-- Триггер AFTER (Если у добавленного напитока количество быстр. угл. на 100 г больше чем у наибольшего напитка из завтраков, то тогда новый напиток заменяется на новый в этом завтраке)
CREATE TRIGGER drinks_insert ON drinks
AFTER INSERT 
AS
BEGIN
	
	IF 
	(SELECT Fast_carbs_grams_per_100_grams
	FROM INSERTED) 
		>
	(SELECT TOP 1 Fast_carbs_grams_per_100_grams
	FROM breakfast INNER JOIN drinks ON breakfast.ID_drinks = drinks.ID
	ORDER BY Fast_carbs_grams_per_100_grams DESC)
	BEGIN	
		UPDATE breakfast SET ID_drinks = 	(SELECT ID FROM INSERTED) WHERE ID = 
		(SELECT TOP 1 breakfast.ID
		FROM breakfast INNER JOIN drinks ON breakfast.ID_drinks = drinks.ID
		ORDER BY Fast_carbs_grams_per_100_grams DESC)
	END

END


INSERT drinks(ID, Drink_name, Fast_carbs_grams_per_100_grams, Above_average_rating, Temperature_serving_C, Color) VALUES (202,'fdf',90,1,23,'white')
DELETE FROM drinks WHERE ID=202

GO
-- Триггер INSTEAD OF (Замена инсерта инсертом, кек)
CREATE TRIGGER cakes_insert ON cakes
INSTEAD OF INSERT
AS
BEGIN

  INSERT INTO cakes
       SELECT ID, Dish_name, Number_servings, Fats_grams_per_100_grams, With_fruits, Сooking_difficulty
       FROM inserted
END;

GO
-- Хранимая процедура без параметрами ( от 0 до 10 записей из завтраков )
CREATE PROCEDURE get_some_food 
AS	
BEGIN
	DECLARE @n integer = 0
	SET @n = CAST(RAND()*10 AS int)
	PRINT @n
	
	SELECT TOP (@n) *
	FROM breakfast 
END

-- Вызов
EXECUTE get_some_food


GO
-- Рекрусия (что-то для вывода четного, нечетного) добавить временную таблицу или передавать ее название UPD передача названия ничего не дает, кроме доступа к метаданным; Создание временной таблицы ничего не дает, т.к. передача таблицы в хран. процедуру невозможна
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

EXECUTE rec_found_fac_1 4, DEFAULT

GO
-- С курсором (что и в начале, только по отдельности из курсора)
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

EXECUTE get_some_drinks_from_food

GO
-- Хранимая процедура с доступом к метаданным(?)
CREATE PROCEDURE get_atributs @name varchar(20)
AS
BEGIN
	SELECT COLUMN_NAME FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = @name
END

GO
EXECUTE get_atributs 'cakes'


GO
-- Скалярная функция (апгрейд рандома до frand(int min, int max)) -- RAND скорее всего как-то изменяет состояние БД
GO
CREATE VIEW vRand(V) AS SELECT RAND();

GO
CREATE FUNCTION fRand1(@min int, @max int) 
RETURNS datetime 
BEGIN 
	DECLARE @k datetime = GETDATE()
	RETURN @k
END

GO
select dbo.fRand1(1, 5)



GO
-- Табличная функция многоопреторная
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

GO
SELECT * FROM get_cakes()

GO
-- обычная
CREATE FUNCTION get_sum_fast_gram(@n int)
RETURNS TABLE 
AS
RETURN 
(
	SELECT Fats_grams_per_100_grams + @n AS new FROM cakes
)

GO
SELECT * FROM get_sum_fast_gram(2)

GO
-- Рекурския 
CREATE FUNCTION get_sum_fast_gram_fac(@n int, @m int = 1)
RETURNS @res table
(
Fats_grams_per_100_grams int
)
AS
BEGIN
	SET @m *= @n
	SET @n -= 1
	IF @n > 0
		INSERT INTO @res (Fats_grams_per_100_grams) SELECT * FROM get_sum_fast_gram_fac(@n, @m)
	IF @n = 0
		INSERT INTO @res (Fats_grams_per_100_grams) SELECT Fats_grams_per_100_grams + @m AS new FROM cakes
		RETURN
END

GO

SELECT * FROM get_sum_fast_gram_fac(3,DEFAULT)


-- DDL Триггер
GO
CREATE TRIGGER tabl_create ON Database
AFTER CREATE_TABLE
AS
BEGIN
	SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 
	(SELECT TOP 1 name FROM sys.all_objects ORDER BY modify_date DESC)

	--SELECT TOP 1 * FROM sys.all_objects ORDER BY modify_date DESC
END

CREATE TABLE kek (KEK int)


