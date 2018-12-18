
-- 1. �������� ��������� (���������� ��������� ��������� �� 100 � ������ ��� ����� 50)
SELECT Dish_name, Slow_carbs_grams_per_100_grams
FROM breakfast
WHERE Slow_carbs_grams_per_100_grams >= 50

-- 2. �������� BETWEEN (����� ������������� �������� �� 30 �� 60 �����)
SELECT Dish_name, Cooking_time
From breakfast
WHERE Cooking_time BETWEEN '00:05:00' AND '00:15:00'
ORDER BY Cooking_time

-- 3. �������� LIKE (�������, ������� ������������ � �������, � ��� ���� ������� ������)
SELECT TOP 1 Drink_name
FROM drinks
WHERE Drink_name LIKE '%juice%'

-- 4. �������� IN � ��������� ����������� (��� �������� ���������, � ������� ������������ ������� ���������� �����) ���� ��� ������������
SELECT breakfast.Dish_name, drinks.Color
FROM breakfast LEFT OUTER JOIN drinks on breakfast.ID_drinks = drinks.ID
WHERE breakfast.ID_drinks IN
(
 SELECT drinks.ID
 FROM drinks
 WHERE Color = 'crimson'
) 

-- 5. �������� EXISTS � ��������� ����������� (�������� ��� �������� ��������, � �������� ������� ����������� ���, ��� ����, ����� �� �� ������������ �� � ����� � ����� ��������)
SELECT *
FROM drinks AS D
WHERE Drink_name LIKE '%juice%' AND NOT EXISTS
	(
	SELECT *
	FROM breakfast
	WHERE ID_drinks = D.ID
	)

-- 6. �������� ��������� � ��������� (�������� �������, � ������� ����������� ������ ������ ��� � ������� ������� ������� �����)
SELECT ID, Drink_name, Temperature_serving_C
FROM drinks
WHERE Temperature_serving_C > ALL
	(
	SELECT Temperature_serving_C
	 FROM drinks
	 WHERE Color = 'yellow'
	)



-- 7. ���������� ������� � ���������� �������� (������� ����������� ���� �������� � ���������, ����������� � AVG � ����� SUM & COUNT)
SELECT AVG(Temp_Kelvin) AS 'Actual AVG',
SUM(Temp_Kelvin) / COUNT(ID) AS 'Calc AVG'
FROM 
	(
	SELECT ID, SUM(Temperature_serving_C + 273.15) AS Temp_Kelvin
	FROM drinks
	GROUP BY ID
	 ) AS AVG_Kelvin

-- 8. ��������� ���������� � ���������� �������� (�������� ID ... ��� ��������� �� ������� �����, ��� ������� ���������� ���� ���������� ������ ������� ��� ��������� ������ ����� �� ����� ������������ ���������� ���� ���������� ������� ������� ��� ��������� ������ �����, ��� ��������� �� ������� �����)

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




-- 9. ������� ��������� CASE (���� ���� �� ���������, �� '�� ���������', � ����� '�� ���������')
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

-- 10. ��������� ��������� CASE (���� ����������� ������ ������� < 20 - �� �������, ...)
SELECT Drink_name,
CASE
WHEN Temperature_serving_C < 20 THEN 'Cold'
WHEN Temperature_serving_C < 40 THEN 'Normal'
WHEN Temperature_serving_C > 60 THEN 'Very Hot'
ELSE 'Hot'
END AS Price
FROM drinks

-- 11. �������� ����� ��������� ��������� ������� (������� ��� ID, � ����� ���� ����������, ��� ID != NULL, �������� �� ������, � ����� ID, � ������� ��������� � ����� �������  xz)
SELECT ID,
SUM(days_update_rate) AS all_sum
INTO new
FROM products_list
WHERE ID IS NOT NULL
GROUP BY ID

SELECT * FROM new

DROP TABLE new

-- 12. SELECT ��������� ��������������� ���������� � �������� ����������� ������ � ����������� FROM. (�������� ��������� � 1 �� �������� ����� ���� ���������� ��� �������� � ����� ID �� ID � ���� ����� �� ������� ���������)
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

-- 13. SELECT ��������� ���������� � ������� ����������� 3. (�������� �������� ��������, � ������� ������ �������, ������� ��������� ����� � ���������� ������ ���������� � ������ ���������=Yulia)
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

-- 14.  ����������� GROUP BY, �� ��� ����������� HAVING. (�������� ��� ���������, ������, ������� �������������, ����������� ������������� �� ������� �����, ��� ������ ������)
SELECT P.Director_name,
P.Country,
AVG(OD.days_update_rate) AS AvgDayes,
MIN(OD.days_update_rate) AS MinDayes
FROM pepsi_factories P LEFT OUTER JOIN products_list OD ON OD.ID_factories = P.ID
WHERE Country = 'Russia'
GROUP BY P.Director_name, P.Country

-- 15.  ����������� GROUP BY � ����������� HAVING. (������� ����������� � ������� �����, ��� ���� ����� ������ ��� ���������� � �������)
SELECT color, AVG(Temperature_serving_C) AS SR
FROM drinks
GROUP BY color
HAVING color LIKE 'crimson' OR color LIKE 'black'

-- 16. ������������ INSERT (�������� � ������� ������� ������ � ID=108, ������=...)
DELETE cakes WHERE ID = 108
INSERT cakes(Id, Dish_name, Number_servings, Fats_grams_per_100_grams, With_fruits, �ooking_difficulty)
VALUES (108,'Best cake with orange', 2, 46, 1, 'hard')

-- 17. INSERT ������� � ������� ��������������� ������ ������ ���������� ����������.
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



--18. ������� Update (�������� ������� ������� ���������/100 ������ � ������� �������� � ID=35)
UPDATE drinks
SET Fast_carbs_grams_per_100_grams = Fast_carbs_grams_per_100_grams / 100
WHERE ID = 35 

-- 19. UPDATE �� ��������� ����������� � ����������� SET (�������� ������� ������� ��������� � ������� �������� � ������ � ID=35 �� ������� �������� ������� ��������� � ���� ��������)
UPDATE drinks
SET Fast_carbs_grams_per_100_grams =
(
	SELECT AVG(Fast_carbs_grams_per_100_grams)
	FROM drinks
)
WHERE ID = 35

--20. ������� Delete (������� ������ �� ��������, ��� ID=NULL)
DELETE drinks
WHERE ID IS NULL

-- 21. DELETE � ��������� ��������������� ����������� � ����������� WHERE (������� ���, ������� ������ � ������� � ������� ����� ������ 500)
DELETE FROM drinks
WHERE ID IN
(
 SELECT *
 FROM drinks LEFT OUTER JOIN breakfast
 ON drinks.ID = breakfast.ID_drinks
 WHERE 
 breakfast.Average_cost_rub > 500
 )

 -- 22. SELECT, ������������ ������� ���������� ��������� ��������� (OTB - temperature_calc � �������� above, ����� � ��������, ����� ������� ����������� ���� �������� ���� ������ 40 � ������� ��, � ���� ������ �������)
WITH temperature_calc(above)
AS
(
 SELECT AVG(Temperature_serving_C)
 FROM drinks
)
SELECT Drink_name, Temperature_serving_C
FROM drinks
where (SELECT above FROM temperature_calc) > 40 AND Temperature_serving_C > (SELECT above FROM temperature_calc)

-- 23. ���������� SELECT, ������������ ����������� ���������� ��������� ���������.
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


-- 24. ������� �������. ������������� ����������� MIN/MAX/AVG OVER() (��� ������ �������� ������ ������� ������� ������� �������� ����������� )
SELECT D.ID,
D.Temperature_serving_C,
D.Drink_name,
OD.days_update_rate,
AVG(OD.days_update_rate) OVER(PARTITION BY D.ID, D.Drink_name) AS AvgTemp,
MIN(OD.days_update_rate) OVER(PARTITION BY D.ID, D.Drink_name) AS MinTemp,
MAX(OD.days_update_rate) OVER(PARTITION BY D.ID, D.Drink_name) AS MaxTemp
FROM drinks D LEFT OUTER JOIN products_list OD ON OD.ID_drinks = D.ID

 
 -- 25. ROW_NUMBER() �������� ������ ������
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


-- ��� �������
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


-- ������ ����(
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