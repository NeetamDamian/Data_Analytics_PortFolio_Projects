SELECT * 
FROM SQLtutorial2..TR_OrderDetails



-- selecting the maximum quantity int the order detail

SELECT MAX(Quantity) as maxQuantity, count(*)
FROM SQLtutorial2..TR_OrderDetails

-- finding the unique product in all the transactions and sorting to see the quantity of products for each unique elements
SELECT distinct(ProductID), Quantity
FROM SQLtutorial2..TR_OrderDetails
order by Quantity DESC, ProductID ASC


-- checking for unique properties in the propertyID
SELECT distinct(PropertyID)
FROM SQLtutorial2..TR_OrderDetails

-- finding the product category that has the maximum amount products
SELECT ProductCategory, count(*)
FROM SQLtutorial2..TR_Products
group by ProductCategory
order by 2 desc

-- finding the state where most stores are present

SELECT PropertyState, count(*)
FROM SQLtutorial2..TR_PropertyInfo
group by PropertyState
order by 2 desc


--top 5 productIDs that did the maximum sales in terms of quantity
SELECT ProductID,  sum(Quantity) as Total_Quantity
FROM SQLtutorial2..TR_OrderDetails
group by ProductID
order by 2 desc
	OFFSET 5 ROWS FETCH NEXT 5 ROWS ONLY


-- Top 5 property ID that did maximum Quantity

SELECT PropertyID,  sum(Quantity) as Total_Quantity
FROM SQLtutorial2..TR_OrderDetails
group by PropertyID
order by 2 desc
	OFFSET 5 ROWS FETCH NEXT 5 ROWS ONLY

-- finding out the top 5 product names that did the maximum sales in terms of quantity
-- joining the order table and the product table


select pro.ProductName,  sum(ord.Quantity) as total_Quantity
FROM SQLtutorial2..TR_OrderDetails ord
join
SQLtutorial2..TR_Products pro
	ON ord.ProductID = pro.ProductID
group by pro.ProductName
order by 2 desc 

--FINDing the top 5 products that did maximum sales

select pro.ProductName,  sum(pro.Price * ord.Quantity) as sales
FROM SQLtutorial2..TR_OrderDetails ord
join
SQLtutorial2..TR_Products pro
	ON 
	pro.ProductID = ord.ProductID
group by pro.ProductName
order by 2 desc
	OFFSET 5 ROWS
	FETCH NEXT 5 ROWS ONLY

-- top 5 cities that did maximum sales
select property.PropertyCity, sum(ord.Quantity*pro.Price) as Sales
FROM SQLtutorial2..TR_Products pro
join
SQLtutorial2..TR_OrderDetails ord
	ON ord.ProductID = pro.ProductID
join
SQLtutorial2..TR_PropertyInfo property
	ON ord.PropertyID = property.[Prop ID]

group by property.PropertyCity
order by 2 desc






	