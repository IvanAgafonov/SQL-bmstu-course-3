CREATE TABLE [dbo].[cakes] (
    [ID]                       INT          NOT NULL,
    [Dish_name]                VARCHAR (30) NULL,
    [Number_servings]          TINYINT      NULL,
    [Fats_grams_per_100_grams] FLOAT (53)   NULL,
    [With_fruits]              BIT          NULL,
    [Сooking_difficulty]       VARCHAR (20) NULL,
    PRIMARY KEY CLUSTERED ([ID] ASC),
    CHECK ([Fats_grams_per_100_grams]>=(0) AND [Fats_grams_per_100_grams]<=(100)),
    CHECK ([Number_servings]>=(0))
);


GO
CREATE TRIGGER cakes_insert ON cakes
INSTEAD OF INSERT
AS
BEGIN

  INSERT INTO cakes
       SELECT ID, Dish_name, Number_servings, Fats_grams_per_100_grams, With_fruits, Сooking_difficulty
       FROM inserted
END;