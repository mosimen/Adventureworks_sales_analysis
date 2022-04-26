use AdventureWorksDW2019
create view customer_table as

select 
	c.customerkey as customer_key,
	c.firstname as first_name, 
	c.lastname as last_name, 
	c.firstname + ' ' + c.lastname as full_name, 
	case
		c.gender 
		when 'M' then 'Male'
		when 'F' then 'Female'
		end as Gender,
	c.datefirstpurchase as date_of_first_purchase, 
	g.city as customer_city -- Joined in Customer City from Geography Table
from 
  DimCustomer as c
  left join DimGeography as g
	on g.geographykey = c.geographykey

--select *
--from customer_table
--order by 
--  customer_key asc -- Order table by CustomerKey

create view date_table as

select DateKey,
	FullDateAlternateKey as date,
	EnglishDayNameOfWeek as day,
	WeekNumberOfYear as week_num_of_year,
	EnglishMonthName as month,
	left(EnglishMonthName,3) as month_code,
	MonthNumberOfYear as month_num_of_year,
	CalendarQuarter as quarter,
	CalendarYear as year
from DimDate
where CalendarYear >=2019

create view product_table as

select 
  p.[ProductKey], 
  p.[ProductAlternateKey] as product_item_code,
  p.[EnglishProductName] as product_name, 
  ps.EnglishProductSubcategoryName as sub_category, -- Joined in from Sub Category Table
  pc.EnglishProductCategoryName as product_category, -- Joined in from Category Table
  p.[Color] as product_color, 
  p.[Size] as product_size, 
  p.[ProductLine] as product_line, 
  p.[ModelName] as product_model_name, 
  p.[EnglishDescription] as product_description, 
  ISNULL (p.Status, 'Outdated') as product_status 
from 
  DimProduct as p
  left join DimProductSubcategory as ps 
	on ps.ProductSubcategoryKey = p.ProductSubcategoryKey 
  left join DimProductCategory as pc 
	on ps.ProductCategoryKey = pc.ProductCategoryKey 
--order by 
--  p.ProductKey asc

create view internet_sales as

select 
  [ProductKey], 
  [OrderDateKey], 
  [DueDateKey], 
  [ShipDateKey], 
  [CustomerKey], 
  [SalesOrderNumber], 
  [SalesAmount]
from 
  FactInternetSales
where 
	left (OrderDateKey, 4) >= YEAR(GETDATE()) -2