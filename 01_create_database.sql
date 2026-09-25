-- 创建进销存数据库 Inventory
-- 含"先删后建"重置，会清空全部数据
--仅用于本地环境

USE master;
GO
-- 若数据库已存在，先断开全部连接再删除（重置用）

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

