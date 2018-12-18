CREATE TABLE DOP(
	ID int,
	Sotrudnik varchar(20), 
	Dostup date) 

CREATE TABLE DOP1(
	ID int,
	Sotrudnik varchar(20), 
	Dostup date,
	Temp_id int) 

CREATE TABLE DOP0(
	ID int,
	Sotrudnik varchar(20), 
	Dostup date,
	Temp_id int) 

INSERT INTO DOP(ID, Sotrudnik, Dostup) VALUES
	(1, 'Ivanov', '16-01-2018'),
	(1, 'Ivanov', '17-01-2018'),
	(1, 'Ivanov', '25-06-2018'),
	(1, 'Ivanov', '30-06-2018')

INSERT INTO DOP1(ID, Sotrudnik, Dostup, Temp_id)
SELECT ID, Sotrudnik, Dostup, 
row_number() OVER(ORDER BY Dostup ASC) AS Temp_id
FROM(
	SELECT ID, Sotrudnik, Dostup, Temp % 2 AS Temp
		FROM(
		SELECT ID, Sotrudnik, Dostup,
		row_number() OVER(ORDER BY Dostup ASC) AS Temp
		FROM DOP) Temp_DOP) Temp_Temp_DOP
WHERE Temp = 1
 
INSERT INTO DOP0(ID, Sotrudnik, Dostup, Temp_id)
SELECT ID, Sotrudnik, Dostup, 
row_number() OVER(ORDER BY Dostup ASC) AS Temp_id
FROM(
	SELECT ID, Sotrudnik, Dostup, Temp % 2 AS Temp
		FROM(
		SELECT ID, Sotrudnik, Dostup,
		row_number() OVER(ORDER BY Dostup ASC) AS Temp
		FROM DOP) Temp_DOP) Temp_Temp_DOP
WHERE Temp = 0


SELECT I.ID, I.Sotrudnik, I.Dostup, O.Dostup FROM DOP1 AS I INNER JOIN DOP0 AS O ON I.Temp_id = O.Temp_id