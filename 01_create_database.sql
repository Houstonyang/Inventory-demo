USE master
GO
if DB_ID('Inventory') IS NOT NULL
begin
    alter database Inventory SET SINGLE_USER WITH ROLLBACK IMMEDIATE
    drop database Inventory
end
GO

CREATE DATABASE Inventory COLLATE Chinese_PRC_CI_AS
GO

USE Inventory
GO

SELECT DB_NAME() AS CurrentDB