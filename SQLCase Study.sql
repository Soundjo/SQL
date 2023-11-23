/*Today is June 5, 2014. The Sales Manager wants to know how many road bikes were sold last
month and for the same month last year. You know that the Product Subcategory name is "Road
Bikes" and you only want to write one query to get the answer.
List, in this order, the year of the orders, the name of the months, and the total quantity sold, and
the total revenue.*/


Select Year(s.OrderDate) as 'year', DateName(Month, s.OrderDate) as Month, 
		Sum(OrderQty) as QtySold, Cast(Sum(LineTotal) as decimal(10,2)) as Revenue
from Sales.SalesOrderHeader s
	Join Sales.SalesOrderDetail d on s.SalesOrderID=d.SalesOrderID
	Join Production.Product p on p.ProductID=d.ProductID
	Join Production.ProductSubcategory sb on sb.ProductSubcategoryID=p.ProductSubcategoryID
Where sb.Name='Road Bikes' and MONTH(OrderDate)=5 and (YEAR(OrderDate)=2014 or YEAR(OrderDate)=2013)
Group by sb.ProductSubcategoryID, YEAR(s.OrderDate), DateName(Month, s.OrderDate)

/*After reviewing the numbers provided above, the Sales Manager would like more information on a
particular road bike – Product Number BK-R93R-48. How many are currently available for sale? */


Select Name, Sum(Quantity) as Qty
From Production.Product p
	Join Production.ProductInventory i
	on p.ProductID=i.ProductID
Where ProductNumber= 'BK-R93R-48'
Group By Name


/*The Sales Manager is now concerned that there will be enough product of this model on hand for
the holiday season at the end of the year. They believe they can sell in excess of 200 during that
period.
You need to produce a report listing the components that are used to manufacture this bicycle
along with the QtyOnHand and QtyOnOrder of each component. */

Select pr.Name, Sum(i.Quantity) as QtyInHand, Sum(o.OrderQty) as QtyOnOrder
From Production.Product p
	Join Production.BillOfMaterials b   on p.ProductID=b.ProductAssemblyID
	Left Join Production.ProductInventory i on b.ComponentID=i.ProductID
	Left Join Purchasing.PurchaseOrderDetail o on o.ProductID=b.BillOfMaterialsID
	join Production.Product pr on pr.ProductID=b.ComponentID
	Where p.ProductNumber= 'BK-R93R-48'
Group by pr.name



/*. How many of the bikes, product number BK-R64Y-40 were sold in Nov/Dec 2013?
List, in this order, the product name, the Total#Sold, and the TotalRevenue.*/

Select Name, Sum(OrderQty) as TotalSold, Sum(LineTotal) as Revenue
From Sales.SalesOrderHeader s
	Join Sales.SalesOrderDetail d on s.SalesOrderID=d.SalesOrderID
	Join Production.Product p on p.ProductID=d.ProductID
Where ProductNumber='BK-R64Y-40' and YEAR(OrderDate)=2013 and (MONTH(OrderDate)=11 Or Month(OrderDate)=12)
Group By Name

/*Do you think that the Sales Manager is correct on the sales forecast? Base your answer on
evidence. For example compare the growth between 2012 and 2013 or two other comparable time
periods in 2013 and 2014. */

Select Year(s.OrderDate) as Year, Sum(OrderQty) as Qty, Sum(LineTotal) As Revenue
from Sales.SalesOrderHeader s
	Join Sales.SalesOrderDetail d on s.SalesOrderID=d.SalesOrderID
	Join Production.Product p on p.ProductID=d.ProductID
	Join Production.ProductSubcategory sb on sb.ProductSubcategoryID=p.ProductSubcategoryID
Where sb.ProductSubcategoryID=2 and YEAR(OrderDate) in (2012, 2013,2014)
Group by sb.ProductSubcategoryID, YEAR(s.OrderDate)
Order by YEAR(s.OrderDate)

Select Year(s.OrderDate) as Year, Sum(OrderQty) as Qty
from Sales.SalesOrderHeader s
	Join Sales.SalesOrderDetail d on s.SalesOrderID=d.SalesOrderID
	Join Production.Product p on p.ProductID=d.ProductID
Where ProductNumber= 'BK-R93R-48'
Group By YEAR(s.OrderDate)



/*Which bicycles are the 3 highest sellers based on Revenue in the first five months of 2014?
List, in this order, the product name and the Revenue.*/

Select Top 3 p.Name, Sum(LineTotal) as Revenue
From Sales.SalesOrderHeader s
	Join Sales.SalesOrderDetail d on s.SalesOrderID=d.SalesOrderID
	Join Production.Product p on p.ProductID=d.ProductID
	Join Production.ProductSubcategory sb on sb.ProductSubcategoryID=p.ProductSubcategoryID
	Join Production.ProductCategory pc on pc.ProductCategoryID=sb.ProductCategoryID
Where MONTH(OrderDate) in (1,2,3,4,5) and pc.Name='Bikes' and YEAR(OrderDate)=2014
Group By p.Name
Order By Sum(LineTotal) desc



/*Which bicycles are the 3 highest sellers based on quantity in the first five months of 2014?
List, in this order, the product name and the QtySold.*/

Select Top 3 p.Name, Sum(OrderQty) as QtySold
from Sales.SalesOrderHeader s
	Join Sales.SalesOrderDetail d on s.SalesOrderID=d.SalesOrderID
	Join Production.Product p on p.ProductID=d.ProductID
	Join Production.ProductSubcategory sb on sb.ProductSubcategoryID=p.ProductSubcategoryID
	Join Production.ProductCategory pc on pc.ProductCategoryID=sb.ProductCategoryID
Where MONTH(OrderDate) in (1,2,3,4,5) and pc.Name='Bikes' and YEAR(OrderDate)=2014
Group By p.Name
Order By Sum(OrderQty) desc


/*What is the product name, revenue, total cost, profit, and profit margins (in this order) on each
model of road bikes in the first five months of 2014?*/
Select p.Name, Sum(LineTotal) As Revenue, 
		Sum(d.OrderQty*h.StandardCost) As Cost,
		Sum(LineTotal)-Sum(d.OrderQty*h.StandardCost) As Profit,
		Cast(((Sum(LineTotal)-Sum(d.OrderQty*h.StandardCost))*100/Sum(LineTotal)) as decimal(6,4)) AS 'Margin(%)'
From Sales.SalesOrderHeader s
	Join Sales.SalesOrderDetail d on s.SalesOrderID=d.SalesOrderID
	Join Production.Product p on p.ProductID=d.ProductID
	Join Production.ProductSubcategory sb on sb.ProductSubcategoryID=p.ProductSubcategoryID
	Join Production.ProductCostHistory h on h.ProductID=d.ProductID
Where MONTH(OrderDate) in (1,2,3,4,5) and sb.ProductSubcategoryID=2 and YEAR(OrderDate)=2014
Group By p.Name
Order By [Margin(%)] desc