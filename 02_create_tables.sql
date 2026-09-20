USE Inventory
GO


--商品
create table dbo.Goods
(
	GoodsId int identity(1, 1) primary key,
	GoodsCode nvarchar(50) not null unique,
	GoodsName nvarchar(100) not null,
	GoodSize nvarchar(100)null,
	Unit nvarchar(20) not null,
	IsActive bit not null default 1,

	CreateTime datetime2 not null default sysdatetime()
	
)

select * from Goods



--供应商
create table dbo.Supplier
(
	SupplierId int identity(1, 1) primary key,
	SupplierCode nvarchar(50) not null unique,
	SupplierName nvarchar(100) not null,
	Contact nvarchar(50),
	Phone nvarchar(50),

	CreateTime datetime2 not null default sysdatetime()

)
select * from Supplier





--客户
create table dbo.Customer
(
	CustomerId int identity(1, 1) primary key,
	CustomerCode nvarchar(50) not null unique,
	CustomerName nvarchar(100) not null,
	Contact nvarchar(50),
	Phone nvarchar(50),

	CreateTime datetime2 not null default sysdatetime()

)
select*from Customer



--仓库
create table dbo.Warehouse
(
	WarehouseId int identity(1, 1) primary key,
	WarehouseCode nvarchar(50) not null unique,
	WarehouseName nvarchar(100) not null,
	Location nvarchar(200) null,
	IsActive bit not null default 1,

	CreateTime datetime2 not null default sysdatetime()

)
select*from Warehouse
