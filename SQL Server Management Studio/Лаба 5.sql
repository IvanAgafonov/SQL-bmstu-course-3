
-- AUTO, RAW, PATH, EXPLICIT
SELECT b.Dish_name, c.Dish_name AS Cake_name FROM breakfast AS b INNER JOIN cakes AS c ON b.ID_cakes=c.id Where b.ID<10 FOR XML AUTO -- ������������� ��������
SELECT * FROM NUM1 FOR XML RAW -- ������ ������(������) ������������ �������� <row>
SELECT * FROM breakfast WHERE ID <=3 FOR XML PATH -- ��� EXPLICIT, �� �������, ������ ������ � ��������� �����, ������� ������������ �������� ���������� ��������

SELECT  1 AS TAG, -- ���� ������, TAG/PARANT - ��������, [a!b!c] a - ����������� ��������, b - tag, c - ����������� ��������
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
SELECT * FROM NUM1 FOR XML RAW, TYPE -- ��� xml, � �� varchar
SELECT * FROM NUM1 FOR XML RAW, ELEMENTS -- ������� ��������� �� � ��������, � � �������� ��������� 
SELECT * FROM NUM1 FOR XML RAW, ELEMENTS XSINIL -- ���� ���� �������� NULL, �� ��������� ��������, def ����� �� ���������
SELECT * FROM NUM1 FOR XML RAW, ROOT -- �������� ������� (Name)
-- ��� SGML, �� ���� XML � HTML, DTD(Document Type Definition) ���� �� ��������� ���������, �� �-�� ���� ������ �� ���������,
-- ������ XDR(XML-Data Reduced), ���� �����, ��������� ����, �� ��� �� ������, W3C �������� XSD(XML Schema definition).
SELECT * FROM drinks WHERE ID <=3 FOR XML RAW, XMLDATA -- XDR
SELECT * FROM NUM1 FOR XML RAW, XMLSCHEMA -- XSD (urn:NameSpace)
SELECT * FROM NUM1 FOR XML RAW, BINARY BASE64  -- ���� ���-�� � �������� ��������

-- OPENXML
--��������� ����������
DECLARE @XML_Doc XML;
DECLARE @XML_Doc_Handle INT;

--��������� XML ��������
SET @XML_Doc = (
			SELECT ID, var1, valid_from_dttm, valid_to_dttm
			FROM NUM1
			FOR XML PATH ('Product'), TYPE, ROOT ('Products')
			);
--�������������� XML ��������
EXEC sp_xml_preparedocument @XML_Doc_Handle OUTPUT, @XML_Doc;

--��������� ������ �� XML ���������
SELECT *
FROM OPENXML (@XML_Doc_Handle, '/Products/Product', 2)
WITH (
	ID int,
	var1 varchar(20),
	valid_from_dttm date,
	valid_to_dttm date
    );
--������� ���������� XML ���������
EXEC sp_xml_removedocument @XML_Doc_Handle;


GO
-- OPENROWSET
--��������� ����������
DECLARE @XML_Doc XML;
DECLARE @XML_Doc_Handle INT;

SELECT @XML_Doc = C FROM OPENROWSET(BULK 'C:\Users\sudde\Documents\SQL Server Management Studio\kek.xml', SINGLE_BLOB) AS TEMP(c)

--�������������� XML ��������
EXEC sp_xml_preparedocument @XML_Doc_Handle OUTPUT, @XML_Doc;

--��������� ������ �� XML ���������
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
--������� ���������� XML ���������
EXEC sp_xml_removedocument @XML_Doc_Handle;