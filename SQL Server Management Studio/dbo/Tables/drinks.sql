CREATE TABLE [dbo].[drinks] (
    [ID]                             INT          NOT NULL,
    [Drink_name]                     VARCHAR (30) NULL,
    [Fast_carbs_grams_per_100_grams] FLOAT (53)   NULL,
    [Above_average_rating]           BIT          NULL,
    [Temperature_serving_C]          INT          NULL,
    [Color]                          VARCHAR (20) NULL,
    PRIMARY KEY CLUSTERED ([ID] ASC),
    CHECK ([Fast_carbs_grams_per_100_grams]>=(0) AND [Fast_carbs_grams_per_100_grams]<=(100))
);


GO
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
