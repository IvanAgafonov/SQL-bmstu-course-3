sp_configure 'clr enabled', 1
go
reconfigure
go

EXEC sp_configure 'show advanced options', 1
RECONFIGURE;
EXEC sp_configure 'clr strict security', 0;
RECONFIGURE;

CREATE ASSEMBLY CLRFunctions FROM 'C:\Users\sudde\Documents\SQL Server Management Studio\SqlFunction1.dll' 
go


CREATE FUNCTION [dbo].SqlFunction1()
RETURNS nvarchar(max) WITH EXECUTE AS CALLER
AS 
EXTERNAL NAME CLRFunctions.UserDefinedFunctions.SqlFunction1
go


-- Скалярная функция
select dbo.Rand100()
go

--Агрегатная функция (соединение строк через точку с запятой)
CREATE TABLE kek (kek_name varchar(20))
INSERT INTO kek(kek_name) VALUES ('Вася'),('Петя'),('Нядя'),('Юлия'),('Андрей')

SELECT dbo.Concatenator(kek_name) AS stroka 
FROM KEK

-- Табличная, возвращает символ|номер в Аски табл
SELECT * FROM dbo.NameToAscii ('Вася Петя Надя Юлия Андрей' )
GO

--Хранимая процедура, (Выбор случайного числа записей(?)) (Вставка чего-то)
CREATE TABLE breakfast (kek_name varchar(20))
INSERT INTO breakfast(kek_name) VALUES ('Яйцо'),('Сосиски'),('Коффе'),('Каша'),('Яблоко')

EXECUTE Get_some_new_food
GO

--Триггер, на кек, замена инсерта инсертом
INSERT INTO kek(kek) VALUES (2)

--Свой тип эмеил
CREATE TABLE TestTable(
                id int,
                mail Email
)

INSERT INTO TestTable (id,mail) VALUES (5,'test1@example.com')
INSERT INTO TestTable (id,mail) VALUES (6,'test1')



