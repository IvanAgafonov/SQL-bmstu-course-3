
-- AUTO, RAW, PATH, EXPLICIT
SELECT b.Dish_name, c.Dish_name AS Cake_name FROM breakfast AS b INNER JOIN cakes AS c ON b.ID_cakes=c.id Where b.ID<10 FOR XML AUTO -- Эврестическая иерархия
SELECT * FROM NUM1 FOR XML RAW -- Каждая запись(строка) соответсвует элементу <row>
SELECT * FROM breakfast WHERE ID <=3 FOR XML PATH -- как EXPLICIT, но попроще, каждая запись в отдельном блоке, столбцу соответсвует значение вложенного элемента

SELECT  1 AS TAG, -- Если сложна, TAG/PARANT - иерархия, [a!b!c] a - индификатор элемента, b - tag, c - индификатор атрибута
		0 AS PARENT,
		Dish_name AS [main!1!Dish_name],
		Cooking_time AS [main!1!Cooking_time],
		Slow_carbs_grams_per_100_grams AS [common!2!Slow_carbs_grams_per_100_grams],
		Average_cost_rub AS [common!2!Average_cost_rub],
		Above_average_rating AS [rating!3!Above_average_rating]
FROM breakfast
WHERE ID <= 3
UNION
SELECT  2 AS TAG,
		1 AS PARENT,
		Dish_name AS [main!1!Dish_name],
		Cooking_time AS [main!1!Cooking_time],
		Slow_carbs_grams_per_100_grams AS [common!2!Slow_carbs_grams_per_100_grams],
		Average_cost_rub AS [common!2!Average_cost_rub],
		Above_average_rating AS [rating!3!Above_average_rating]
FROM breakfast
WHERE ID <=3
UNION
SELECT  3 AS TAG,
		1 AS PARENT,
		Dish_name AS [main!1!Dish_name],
		Cooking_time AS [main!1!Cooking_time],
		Slow_carbs_grams_per_100_grams AS [common!2!Slow_carbs_grams_per_100_grams],
		Average_cost_rub AS [common!2!Average_cost_rub],
		Above_average_rating AS [rating!3!Above_average_rating]
FROM breakfast
WHERE ID <=3
FOR XML EXPLICIT


-- TYPE, ELEMENTS, ROOT, XMLDATA, XMLSCHEMA, BINARY BASE64
SELECT * FROM NUM1 FOR XML RAW, TYPE -- Тип xml, а не varchar
SELECT * FROM NUM1 FOR XML RAW, ELEMENTS -- столбцы вставляем не в атрибуты, а в значение элементов 
SELECT * FROM NUM1 FOR XML RAW, ELEMENTS XSINIL -- Если есть значения NULL, то создаются элементы, def ессно не создаются
SELECT * FROM NUM1 FOR XML RAW, ROOT -- Корневой католог (Name)
-- Был SGML, от него XML и HTML, DTD(Document Type Definition) чтоб их структуру проверять, но а-ля типы данных не проверяет,
-- делают XDR(XML-Data Reduced), типа схемы, проверяет норм, но чет не удобно, W3C одобряют XSD(XML Schema definition).
SELECT * FROM drinks WHERE ID <=3 FOR XML RAW, XMLDATA -- XDR
SELECT * FROM NUM1 FOR XML RAW, XMLSCHEMA -- XSD (urn:NameSpace)
SELECT * FROM NUM1 FOR XML RAW, BINARY BASE64  -- Если что-то в двоичном записано

-- OPENXML
--Объявляем переменные
DECLARE @XML_Doc XML;
DECLARE @XML_Doc_Handle INT;

--Формируем XML документ
SET @XML_Doc = (
			SELECT ID, var1, valid_from_dttm, valid_to_dttm
			FROM NUM1
			FOR XML PATH ('Product'), TYPE, ROOT ('Products')
			);
--Подготавливаем XML документ
EXEC sp_xml_preparedocument @XML_Doc_Handle OUTPUT, @XML_Doc;

--Извлекаем данные из XML документа
SELECT *
FROM OPENXML (@XML_Doc_Handle, '/Products/Product', 2)
WITH (
	ID int,
	var1 varchar(20),
	valid_from_dttm date,
	valid_to_dttm date
    );
--Удаляем дескриптор XML документа
EXEC sp_xml_removedocument @XML_Doc_Handle;


GO
-- OPENROWSET
--Объявляем переменные
DECLARE @XML_Doc XML;
DECLARE @XML_Doc_Handle INT;

SELECT @XML_Doc = C FROM OPENROWSET(BULK 'C:\Users\sudde\Documents\SQL Server Management Studio\kek.xml', SINGLE_BLOB) AS TEMP(c)

--Подготавливаем XML документ
EXEC sp_xml_preparedocument @XML_Doc_Handle OUTPUT, @XML_Doc;

--Извлекаем данные из XML документа
SELECT *
FROM OPENXML (@XML_Doc_Handle, '/Products/Product', 2)
WITH (
	ID int,
	var1 varchar(20),
	valid_from_dttm date,
	valid_to_dttm date
    );

/*INSERT INTO NUM1 (ID, var1, valid_from_dttm, valid_to_dttm) SELECT *
FROM
OPENXML (@XML_Doc_Handle, '/Products/Product', 2)
WITH (
	ID int,
	var1 varchar(20),
	valid_from_dttm date,
	valid_to_dttm date
    )*/
--Удаляем дескриптор XML документа
EXEC sp_xml_removedocument @XML_Doc_Handle;