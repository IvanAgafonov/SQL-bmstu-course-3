CREATE TABLE [dbo].[breakfast] (
    [ID]                             INT          NOT NULL,
    [Dish_name]                      VARCHAR (30) NULL,
    [Cooking_time]                   TIME (7)     NULL,
    [Slow_carbs_grams_per_100_grams] FLOAT (53)   NULL,
    [Above_average_rating]           BIT          NULL,
    [Average_cost_rub]               INT          NULL,
    [ID_drinks]                      INT          NOT NULL,
    [ID_cakes]                       INT          NOT NULL,
    PRIMARY KEY CLUSTERED ([ID] ASC),
    CHECK ([Average_cost_rub]>=(0)),
    CHECK ([Slow_carbs_grams_per_100_grams]>=(0) AND [Slow_carbs_grams_per_100_grams]<=(100)),
    FOREIGN KEY ([ID_cakes]) REFERENCES [dbo].[cakes] ([ID]),
    FOREIGN KEY ([ID_drinks]) REFERENCES [dbo].[drinks] ([ID])
);

