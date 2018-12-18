CREATE TABLE [dbo].[pepsi_factories] (
    [ID]             INT       NOT NULL,
    [Workers_amount] INT       NULL,
    [liters_per_day] INT       NULL,
    [Director_name]  CHAR (20) NULL,
    [Country]        CHAR (20) NULL,
    PRIMARY KEY CLUSTERED ([ID] ASC)
);

