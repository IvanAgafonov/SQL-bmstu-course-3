CREATE TABLE cakes
(
	ID int NOT NULL PRIMARY KEY,
	Dish_name varchar(40),
	Number_servings tinyint CHECK (Number_servings >= 0),
	Fats_grams_per_100_grams float CHECK (Fats_grams_per_100_grams >= 0 and Fats_grams_per_100_grams <= 100),
	With_fruits bit,
	Ñooking_difficulty varchar(20)
)

CREATE TABLE drinks
(
	ID int NOT NULL PRIMARY KEY,
	Drink_name varchar(40),
	Fast_carbs_grams_per_100_grams float CHECK (Fast_carbs_grams_per_100_grams >= 0 and Fast_carbs_grams_per_100_grams <= 100),
	Above_average_rating bit,
	Temperature_serving_C  int,
	Color varchar(20)
)

CREATE TABLE breakfast
(
	ID int NOT NULL PRIMARY KEY,
	Dish_name varchar(40),
	Cooking_time time,
	Slow_carbs_grams_per_100_grams float CHECK (Slow_carbs_grams_per_100_grams >= 0 and Slow_carbs_grams_per_100_grams <= 100),
	Above_average_rating bit,
	Average_cost_rub int CHECK (Average_cost_rub >= 0),
	ID_drinks int NOT NULL FOREIGN KEY (ID_drinks) REFERENCES drinks(ID),
	ID_cakes int NOT NULL FOREIGN KEY (ID_cakes) REFERENCES cakes(ID),
)

CREATE TABLE pepsi_factories 
(
	ID int NOT NULL PRIMARY KEY,
	Workers_amount int,
	liters_per_day int,
	Director_name char(40),
	Country char(40)
)

CREATE TABLE products_list 
(
	ID int NOT NULL PRIMARY KEY,
	ID_factories int NOT NULL,
	ID_drinks int NOT NULL,
	days_update_rate int
	FOREIGN KEY (ID_factories) REFERENCES pepsi_factories(ID),
	FOREIGN KEY (ID_drinks) REFERENCES drinks(ID),
)

-- Âñòàâêà èç ôàéëà
--DELETE cakes
--where ID > 100

BULK INSERT cakes
FROM 'C:\Users\sudde\Documents\SQL Server Management Studio\foods.csv'
with(
         FIELDTERMINATOR = ',',
         ROWTERMINATOR = '\n'
      )

