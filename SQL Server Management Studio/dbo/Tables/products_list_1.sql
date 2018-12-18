CREATE TABLE [dbo].[products_list] (
    [ID]               INT NOT NULL,
    [ID_factories]     INT NOT NULL,
    [ID_drinks]        INT NOT NULL,
    [days_update_rate] INT NULL,
    PRIMARY KEY CLUSTERED ([ID] ASC),
    FOREIGN KEY ([ID_drinks]) REFERENCES [dbo].[drinks] ([ID]),
    FOREIGN KEY ([ID_factories]) REFERENCES [dbo].[pepsi_factories] ([ID])
);

