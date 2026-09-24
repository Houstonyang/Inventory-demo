--业务查询示例（只读，可反复执行）
--先按顺序执行 01 → 02 → 03
USE Inventory;
GO

-- 查询1：采购明细清单（多表连接）
-- 用四表连接查采购明细（单号，供应商名，商品名，数量，金额）
-- 每张订单买了什么，从哪个供应商，多少钱
-- 明细表只存 ID，名称类信息通过 JOIN 从档案表取回
select 
po.OrderNo		as 订单号,
s.SupplierName	as 供应商,
g.GoodsName		as 商品,
pd.Quantity		as 数量,
pd.Price		as 单价,
pd.Amount		as 金额

from dbo.PurchaseOrderDetail pd
	
	inner join dbo.PurchaseOrder po on po.OrderId = pd.OrderId
	inner join dbo.Supplier		 s  on s.SupplierId = po.SupplierId
	inner join dbo.Goods	     g  on g.GoodsId = pd.GoodsId

order by po.OrderNo, g.GoodsName;
GO
--输出结果：9行


-- 查询2：供应商采购金额汇总（分组聚合）
-- 有哪一些供应商是主力（按金额降序）
--count(distinct) 去重，因为一张订单可含多行明细
select 
s.SupplierName				as 供应商,
count(distinct po.OrderId)  as 订单数,
sum(pd.Amount)				as 采购总金额

from dbo.PurchaseOrderDetail pd

	join dbo.PurchaseOrder po on po.OrderId = pd.OrderId
	join dbo.Supplier	   s  on s.SupplierId = po.SupplierId

group by s.SupplierName
order by 采购总金额 desc;
GO
--输出结果：4行



-- 查询3：收货跟踪表（订购、实收）
-- 哪些到齐、哪些短交、哪些还在途
-- left join 保留未到货的订购行，isnull 把无匹配的 NULL 显示为 0
-- 实收数量沿 订单 → 入库单 → 入库明细

select
po.OrderNo,
g.GoodsName,
od.Quantity					as 订购数量,
isnull(sum(id.Quantity), 0) as 实收数量,
od.Quantity - isnull(sum(id.Quantity), 0) as 待收数量

from dbo.PurchaseOrderDetail od
	
	inner join dbo.PurchaseOrder po on po.OrderId = od.OrderId
	inner join dbo.Goods		   g on g.GoodsId = od.GoodsId
	left join dbo.PurchaseIn	  pi on pi.OrderId = od.OrderId
	left join dbo.PurchaseInDetail	id on id.PurchaseInId = pi.PurchaseInId and id.GoodsId = od.GoodsId

group by po.OrderNo, g.GoodsName, od.Quantity
order by po.OrderNo, g.GoodsName;
GO

--结果输出：9 行。精密轴承 500/300/200，其余未到货 实收为 0