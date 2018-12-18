
-- 1. Предикат сравнения (Количество медленных углеводов на 100 г больше или равно 50)
SELECT Dish_name, Slow_carbs_grams_per_100_grams
FROM breakfast
WHERE Slow_carbs_grams_per_100_grams >= 50

-- 2. Предикат BETWEEN (Время приготовления завтрака от 30 до 60 минут)
SELECT Dish_name, Cooking_time
From breakfast
WHERE Cooking_time BETWEEN '00:05:00' AND '00:15:00'
ORDER BY Cooking_time

-- 3. Предикат LIKE (Напитки, которые присутствуют в завтрах, и при этом явяются соками)
SELECT TOP 1 Drink_name
FROM drinks
WHERE Drink_name LIKE '%juice%'

-- 4. Предикат IN с вложенным подзапросом (Все названия завтраков, в которых присутствуют напитки малинового цвета) цвет для подверждения
SELECT breakfast.Dish_name, drinks.Color
FROM breakfast LEFT OUTER JOIN drinks on breakfast.ID_drinks = drinks.ID
WHERE breakfast.ID_drinks IN
(
 SELECT drinks.ID
 FROM drinks
 WHERE Color = 'crimson'
) 

-- 5. Предикат EXISTS с вложенным подзапросом (Получить все атрибуты напитков, в названии которых присутсвует сок, при этом, чтобы он не присутсвовал ни в одном в одном завтраке)
SELECT *
FROM drinks AS D
WHERE Drink_name LIKE '%juice%' AND NOT EXISTS
	(
	SELECT *
	FROM breakfast
	WHERE ID_drinks = D.ID
	)

-- 6. Предикат сравнения с квантором (Получить напитки, у которых температура подачи больше чем у каждого напитка желтого цвета)
SELECT ID, Drink_name, Temperature_serving_C
FROM drinks
WHERE Temperature_serving_C > ALL
	(
	SELECT Temperature_serving_C
	 FROM drinks
	 WHERE Color = 'yellow'
	)



-- 7. Агрегатные функции в выражениях столбцов (Средняя температура всех напитков в кельвинах, посчитанная с AVG и через SUM & COUNT)
SELECT AVG(Temp_Kelvin) AS 'Actual AVG',
SUM(Temp_Kelvin) / COUNT(ID) AS 'Calc AVG'
FROM 
	(
	SELECT ID, SUM(Temperature_serving_C + 273.15) AS Temp_Kelvin
	FROM drinks
	GROUP BY ID
	 ) AS AVG_Kelvin

-- 8. Скалярные подзапросы в выражениях столбцов (Получить ID ... Имя директора из заводов пепси, где Среднее количество дней обновления спиков товаров для нынешнего завода пепси не равно минимальному количеству дней обновления списков товаров для нынешнего завода пепси, Имя директора из заводов пепси)

SELECT *
FROM
	(
	SELECT ID,
		(
		SELECT AVG(days_update_rate)
		FROM products_list
		WHERE products_list.ID_factories = pepsi_factories.ID
		) AS AvgDays
			,
		(
		SELECT MIN(days_update_rate)
		FROM products_list
		WHERE products_list.ID_factories = pepsi_factories.ID
		) AS MinDays
			,
		Director_name
	FROM pepsi_factories
	) AS new
WHERE AvgDays != MinDays




-- 9. Простое выражение CASE (Если цвет не малиновый, то 'не малиновый', а иначе 'да малиновый')
SELECT Drink_name,
CASE Color
	WHEN 'orange' THEN 'not crimson'
	WHEN 'yellow' THEN 'not crimson'
	WHEN 'black' THEN 'not crimson'
	WHEN 'red' THEN 'not crimson'
	WHEN 'white' THEN 'not crimson'
	WHEN 'pink' THEN 'not crimson'
	ELSE 'yes crimson'
END 
FROM drinks

-- 10. Поисковое выражение CASE (Если температура подачи напитка < 20 - то холодно, ...)
SELECT Drink_name,
CASE
WHEN Temperature_serving_C < 20 THEN 'Cold'
WHEN Temperature_serving_C < 40 THEN 'Normal'
WHEN Temperature_serving_C > 60 THEN 'Very Hot'
ELSE 'Hot'
END AS Price
FROM drinks

-- 11. Создание новой временной локальной таблицы (Получим все ID, и сумму дней обновлений, где ID != NULL, разделим на группы, в одной ID, и запишем результат в новую таблицу  xz)
SELECT ID,
SUM(days_update_rate) AS all_sum
INTO new
FROM products_list
WHERE ID IS NOT NULL
GROUP BY ID

SELECT * FROM new

DROP TABLE new

-- 12. SELECT вложенные коррелированные подзапросы в качестве производных таблиц в предложении FROM. (напитики объединяя с 1 по убыванию суммы дней обновления для напитков с одним ID по ID и тоже самое со среднем значением)
SELECT ID, days_update_rate
FROM products_list
where ID_drinks=33

SELECT Drink_name
FROM drinks JOIN
	(
	 SELECT TOP 1  ID_drinks,  SUM(days_update_rate) AS SQ
	 FROM products_list
	 GROUP BY ID_drinks
	 ORDER BY SQ DESC
	) AS OD ON OD.ID_drinks = drinks.ID
UNION
SELECT Drink_name
FROM drinks JOIN
	(
	SELECT TOP 1 ID_drinks, AVG(days_update_rate) AS SR
	 FROM products_list
	 GROUP BY ID_drinks
	 ORDER BY SR DESC
	) AS OD ON OD.ID_drinks = drinks.ID

-- 13. SELECT вложенные подзапросы с уровнем вложенности 3. (Получить названия завтрака, в который входит напиток, который выпускает завод с наибольшим числом работников и именем директора=Yulia)
SELECT ID, Dish_name
FROM breakfast
WHERE ID_drinks =
	(
		SELECT ID
		FROM drinks
		where ID =
		(
			SELECT ID_drinks 
			FROM products_list
			WHERE ID_factories = 
				(
					SELECT ID
					FROM pepsi_factories
					WHERE Workers_amount = 
					(
						SELECT max(Workers_amount)
						FROM pepsi_factories
						WHERE Director_name = 'Yulia'
					)					
				)

		)
	)

-- 14.  предложения GROUP BY, но без предложения HAVING. (Получить имя директора, Страну, среднее периодичность, минимальная переодичность из заводов пепси, где страна Россия)
SELECT P.Director_name,
P.Country,
AVG(OD.days_update_rate) AS AvgDayes,
MIN(OD.days_update_rate) AS MinDayes
FROM pepsi_factories P LEFT OUTER JOIN products_list OD ON OD.ID_factories = P.ID
WHERE Country = 'Russia'
GROUP BY P.Director_name, P.Country

-- 15.  предложения GROUP BY и предложения HAVING. (Средняя температура у каждого цвета, при этом вывод только для малинового и черного)
SELECT color, AVG(Temperature_serving_C) AS SR
FROM drinks
GROUP BY color
HAVING color LIKE 'crimson' OR color LIKE 'black'

-- 16. Однострочный INSERT (Вставить в таблицу вычечки строку с ID=108, именем=...)
DELETE cakes WHERE ID = 108
INSERT cakes(Id, Dish_name, Number_servings, Fats_grams_per_100_grams, With_fruits, Сooking_difficulty)
VALUES (108,'Best cake with orange', 2, 46, 1, 'hard')

-- 17. INSERT вставку в таблицу результирующего набора данных вложенного подзапроса.
delete products_list where ID > 100
INSERT products_list (ID_drinks, ID_factories, ID, days_update_rate)
SELECT 
(
	SELECT ID
	FROM drinks
	WHERE ID = 1
), ID, 101, 55
FROM pepsi_factories
WHERE pepsi_factories.Workers_amount = 461



--18. Простой Update (Обновить атрибут быстров углеводов/100 строки в таблице напитков с ID=35)
UPDATE drinks
SET Fast_carbs_grams_per_100_grams = Fast_carbs_grams_per_100_grams / 100
WHERE ID = 35 

-- 19. UPDATE со скалярным подзапросом в предложении SET (Обновить атрибут быстрых углеводов в таблицу напитков у строки с ID=35 на среднее значение быстрых углеводов у всех напитков)
UPDATE drinks
SET Fast_carbs_grams_per_100_grams =
(
	SELECT AVG(Fast_carbs_grams_per_100_grams)
	FROM drinks
)
WHERE ID = 35

--20. Простой Delete (Удалить записи из напитков, где ID=NULL)
DELETE drinks
WHERE ID IS NULL

-- 21. DELETE с вложенным коррелированным подзапросом в предложении WHERE (удалить все, которые входят в завтрак с средней ценой больше 500)
DELETE FROM drinks
WHERE ID IN
(
 SELECT *
 FROM drinks LEFT OUTER JOIN breakfast
 ON drinks.ID = breakfast.ID_drinks
 WHERE 
 breakfast.Average_cost_rub > 500
 )

 -- 22. SELECT, использующая простое обобщенное табличное выражение (OTB - temperature_calc с столбцом above, берем и проверям, чтобы средняя температура всех напитков была больше 40 и вывести те, у кого больше средней)
WITH temperature_calc(above)
AS
(
 SELECT AVG(Temperature_serving_C)
 FROM drinks
)
SELECT Drink_name, Temperature_serving_C
FROM drinks
where (SELECT above FROM temperature_calc) > 40 AND Temperature_serving_C > (SELECT above FROM temperature_calc)

-- 23. Инструкция SELECT, использующая рекурсивное обобщенное табличное выражение.
CREATE TABLE Drevo
( 
number int,
son int 
)

INSERT INTO Drevo(number, son) VALUES 
(1,2),(1,3),
(3,4),(3,5),
(4,6),
(6,7),(6,8),(6,9)

WITH obxod(number, son, lvl) AS
(
	SELECT number, son, 0 AS lvl
	FROM Drevo
	WHERE number = 1
	UNION ALL
		SELECT Drevo.number, Drevo.son,  lvl + 1
		FROM obxod, Drevo
		WHERE obxod.son = Drevo.number
)
SELECT *
FROM obxod


-- 24. Оконные функции. Использование конструкций MIN/MAX/AVG OVER() (Для каждой заданной группы напитка вывести среднее значение температуры )
SELECT D.ID,
D.Temperature_serving_C,
D.Drink_name,
OD.days_update_rate,
AVG(OD.days_update_rate) OVER(PARTITION BY D.ID, D.Drink_name) AS AvgTemp,
MIN(OD.days_update_rate) OVER(PARTITION BY D.ID, D.Drink_name) AS MinTemp,
MAX(OD.days_update_rate) OVER(PARTITION BY D.ID, D.Drink_name) AS MaxTemp
FROM drinks D LEFT OUTER JOIN products_list OD ON OD.ID_drinks = D.ID

 
 -- 25. ROW_NUMBER() удаление полных дублей
SELECT *
FROM(
SELECT drinks.Drink_name, drinks.Fast_carbs_grams_per_100_grams, drinks.ID as DS, breakfast.Dish_name, breakfast.Average_cost_rub, breakfast.ID,
row_number() OVER (PARTITION BY drinks.Drink_name, drinks.Fast_carbs_grams_per_100_grams ORDER BY drinks.ID)  AS counts
FROM drinks CROSS JOIN breakfast
)drinks
WHERE counts = 1

SELECT *
FROM
( 
	SELECT row_number() OVER (PARTITION BY D.ID, D.Drink_name, D.Fast_carbs_grams_per_100_grams, D.Above_average_rating, D.Color, F.ID, F.Drink_name, F.Fast_carbs_grams_per_100_grams, F.Above_average_rating, F.Color ORDER BY D.ID, F.ID) AS counts
	FROM drinks AS F CROSS JOIN drinks AS D
)drinks
WHERE counts != 1

WITH DeleteDouble
AS (
SELECT Drink_name, row_number() OVER (PARTITION BY Drink_name ORDER BY Drink_name) rn
FROM drinks
)
DELETE
FROM DeleteDouble
WHERE rn > 1


-- Доп задание
CREATE TABLE NUM1
(
ID int,
var1 varchar(20),
valid_from_dttm date,
valid_to_dttm date
)

CREATE TABLE NUM2
(
ID int,
var2 varchar(20),
valid_from_dttm date,
valid_to_dttm date
)


INSERT INTO NUM1(ID, var1, valid_from_dttm, valid_to_dttm) VALUES 
(1,'A', '2018-09-01', '2018-09-15'),
(1,'C', '2018-09-16', '2018-09-17'),
(1,'D', '2018-09-18', '2018-09-21'),
(1,'B','2018-09-22', '5999-12-31')


INSERT INTO NUM2(ID, var2, valid_from_dttm, valid_to_dttm) VALUES 
(1,'A', '2018-09-01', '2018-09-15'),
(1,'C', '2018-09-16', '2018-09-17'),
(1,'D', '2018-09-18', '2018-09-20'),
(1,'B','2018-09-21', '5999-12-31')

-- 2
INSERT INTO NUM1(ID, var1, valid_from_dttm, valid_to_dttm) VALUES 
(1,'A', '2018-09-01', '2018-09-15'),
(1,'B','2018-09-16', '5999-12-31')


INSERT INTO NUM2(ID, var2, valid_from_dttm, valid_to_dttm) VALUES 
(1,'C', '2018-09-01', '2018-09-18'),
(1,'B','2018-09-19', '5999-12-31')



WITH obxod(ID, var1, var2, valid_from_dttm, valid_to_dttm) AS
(
	SELECT TOP 1 NUM1.ID, NUM1.var1, NUM2.var2, NUM1.valid_from_dttm, NUM1.valid_to_dttm
	FROM NUM1, NUM2
	UNION ALL
		SELECT  NUM2.ID, NUM1.var1, NUM2.var2, NUM1.valid_from_dttm, NUM2.valid_to_dttm
		FROM NUM2, NUM1, obxod
		WHERE DATEDIFF(day, obxod.valid_from_dttm, NUM2.valid_from_dttm) = 1
)
SELECT *
FROM obxod



SELECT *
FROM NUM1 INNER JOIN NUM2 ON NUM1.ID = NUM2.ID
ORDER BY  NUM1.valid_to_dttm

SELECT *
FROM(
SELECT NUM1.valid_to_dttm, NUM2.valid_to_dttm as l,
CASE 
	WHEN  DATEDIFF(day, NUM1.valid_to_dttm, NUM2.valid_to_dttm) > 0 THEN NUM1.valid_to_dttm
	WHEN  DATEDIFF(day, NUM1.valid_to_dttm, NUM2.valid_to_dttm) < 0 THEN NUM2.valid_to_dttm
END cmp
FROM NUM1 INNER JOIN NUM2 ON NUM1.ID = NUM2.ID) kek
ORDER BY cmp ASC

SELECT *
FROM (SELECT valid_from_dttm, valid_to_dttm
FROM NUM1
UNION 
SELECT valid_from_dttm, valid_to_dttm
FROM NUM2) kek FULL JOIN NUM1 ON kek.valid_to_dttm = NUM1.valid_to_dttm FULL JOIN NUM2 ON kek.valid_to_dttm = NUM2.valid_to_dttm


-- Только даты(
WITH one(valid_from_dttm, new_ID)
AS
(
	SELECT valid_from_dttm,   row_number() OVER(ORDER BY valid_from_dttm ASC) AS new_ID
	FROM(
	SELECT valid_from_dttm
	FROM NUM1
	UNION 
	SELECT valid_from_dttm
	FROM NUM2) tb
)
SELECT valid_from_dttm, valid_to_dttm
FROM(
SELECT valid_to_dttm, row_number() OVER(ORDER BY valid_to_dttm ASC) AS new_ID
FROM(
SELECT valid_to_dttm
FROM NUM2
UNION 
SELECT valid_to_dttm
FROM NUM1)two)tb LEFT JOIN one ON tb.new_ID = one.new_ID