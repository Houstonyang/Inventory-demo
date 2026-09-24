-- 创建全部数据表（基础档案4张 + 采购线4张）
-- 先执行 01_create_database.sql
-- 按顺序创建（档案 → 单据头 → 单据明细）

USE Inventory;
GO


--基础档案（4张）

--商品档案
create table dbo.Goods
(
	GoodsId int identity(1, 1) primary key,
	GoodsCode nvarchar(50) not null unique,		-- 业务编码
	GoodsName nvarchar(100) not null,
	GoodSize nvarchar(100)null,					-- 规格
	Unit nvarchar(20) not null,					-- 单位
	IsActive bit not null default 1,			-- 是否启用

	CreateTime datetime2 not null default sysdatetime(),
	
);
GO



--供应商档案
create table dbo.Supplier
(
	SupplierId int identity(1, 1) primary key,
	SupplierCode nvarchar(50) not null unique,
	SupplierName nvarchar(100) not null,
	Contact nvarchar(50) null,
	Phone nvarchar(50) null,
	
	CreateTime datetime2 not null default sysdatetime(),

);
GO




--客户档案
create table dbo.Customer
(
	CustomerId int identity(1, 1) primary key,
	CustomerCode nvarchar(50) not null unique,
	CustomerName nvarchar(100) not null,
	Contact nvarchar(50) null,
	Phone nvarchar(50) null,

	CreateTime datetime2 not null default sysdatetime(),

);
GO


--仓库档案
create table dbo.Warehouse
(
	WarehouseId int identity(1, 1) primary key,
	WarehouseCode nvarchar(50) not null unique,
	WarehouseName nvarchar(100) not null,
	Location nvarchar(200) null,
	IsActive bit not null default 1,

	CreateTime datetime2 not null default sysdatetime(),

);
GO


--采购线（4张： 2张单据表头+表体）


-- 采购订单（表头：一单一行）
create table dbo.PurchaseOrder
(
	OrderId int identity(1, 1) primary key,
	OrderNo nvarchar(50) not null unique,					-- 业务单号

	SupplierId int not null,								-- 供应商（外键）

	OrderDate date not null,								-- 下单日期
	Status nvarchar(20) not null default 'DRAFT',			-- DRAFT / APPROVED / CLOSED
	Remark nvarchar(200) null,
	
	CreateTime datetime2 not null default sysdatetime(),

	constraint FK_PurchaseOrder_Supplier foreign key(SupplierId) references dbo.Supplier(SupplierId)
	

);
GO


--采购订单明细（表体：一单多行，只存行级信息，不重复存供应商 日期）	
create table dbo.PurchaseOrderDetail
(
	DetailId int identity(1, 1) primary key, 

	OrderId int not null,					-- 属于哪张订单（外键）
	GoodsId int not null,					-- 哪个商品（外键）
	

	Quantity decimal(18, 2) not null,		-- 订购数量
	Price decimal(18, 2) not null,			-- 单价
	Amount decimal(18, 2) not null,			-- 金额 = 数量 × 单价
	CreateTime datetime2  not null default sysdatetime(),
	

	constraint FK_PurchaseOrderDetail_PurchaseOrder foreign key (OrderId) references dbo.PurchaseOrder(OrderId),

	constraint FK_PurchaseOrderDetail_Goods foreign key (GoodsId) references dbo.Goods(GoodsId)

);
GO


--采购入库单（表头：记录 实际到货，OrderId 可空，支持无来源订单的紧急入库）
create table dbo.PurchaseIn
(
	PurchaseInId int identity(1, 1) primary key,
	InNo nvarchar(50) not null unique,			-- 业务单号

	SupplierId int not null,
	WarehouseId int not null,					-- 入哪个仓（外键）
	OrderId int  null,							-- 来源订单（可空）

	InDate date not null,						-- 入库日期
	Status nvarchar(20) not null default 'DRAFT',
	
	CreateTime datetime2 not null default sysdatetime(),

	constraint FK_PurchaseIn_Supplier foreign key (SupplierId) references dbo.Supplier (SupplierId),
	constraint FK_PurchaseIn_Warehouse foreign key (WarehouseId) references dbo.Warehouse (WarehouseId),
	constraint FK_PurchaseIn_PurchaseOrder foreign key (OrderId) references dbo.PurchaseOrder(OrderId)
);
GO


--采购入库单明细（表体：一单多行 记录实收数量）
create table dbo.PurchaseInDetail
(
	DetailId int identity(1, 1) primary key,
	PurchaseInId int not null,					-- 属于哪张入库单（外键）
	GoodsId int not null,						-- 哪个商品（外键）

	Quantity decimal(18, 2) not null,			-- 实收数量
	Price decimal(18, 2) not null,
	Amount decimal(18, 2) not null,

	CreateTime datetime2 not null default sysdatetime(),

	constraint FK_PurchaseInDetail_PurchaseIn foreign key (PurchaseInId) references dbo.PurchaseIn (PurchaseInId),
	constraint FK_PurchaseInDetail_Goods foreign key (GoodsId) references dbo.Goods (GoodsId)

);
GO