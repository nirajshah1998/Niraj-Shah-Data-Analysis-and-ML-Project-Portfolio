-- finding the country wise count of customers....

SELECT 
    Country, COUNT(Id) as 'Customers'
FROM
    customer
GROUP BY Country order by COUNT(Id) DESC;	



-- List of Products which are not discontinued.

select distinct ProductName from product
where IsDiscontinued = 0;


-- the list of companies along with the product name that they are supplying.
SELECT DISTINCT
s.CompanyName, p.ProductName
FROM
supplier s
JOIN product p ON s.Id = p.SupplierId;



-- customer's information who's from 'Mexico'
select distinct Id, FirstName, LastName from customer where Country = 'Mexico';



-- finding the costliest item that is ordered by the customer
select c.Id, c.FirstName, c.LastName, p.ProductName, p.UnitPrice from customer c 
join orders o on c.Id = o.CustomerId
join orderitem oi on o.Id = oi.OrderId
join product p on oi.ProductId = p.Id
join supplier s on s.Id = p.SupplierId
where p.UnitPrice = (select UnitPrice from product order by UnitPrice desc limit 1)
;




-- supplier id who owns highest number of products.
SELECT s.Id, s.CompanyName
FROM customer c
JOIN orders o ON c.Id = o.CustomerId
JOIN orderitem oi ON o.Id = oi.OrderId
JOIN product p ON oi.ProductId = p.Id
JOIN supplier s ON s.Id = p.SupplierId
GROUP BY s.Id ORDER BY COUNT(p.ProductName) DESC LIMIT 1;




-- month wise and year wise count of the orders placed.
SELECT YEAR(OrderDate) AS year, MONTHNAME(OrderDate) AS month, COUNT(OrderNumber) AS count_of_order
FROM orders 
GROUP BY YEAR(OrderDate) , MONTHNAME(OrderDate);




-- Top 5 suppliers and their info:
SELECT s.*, count(oi.Quantity) as total_supplies
FROM customer c
JOIN orders o ON c.Id = o.CustomerId
JOIN orderitem oi ON o.Id = oi.OrderId
JOIN product p ON oi.ProductId = p.Id
JOIN supplier s ON s.Id = p.SupplierId
GROUP BY s.Id, s.CompanyName
ORDER BY total_supplies desc limit 5;




-- country with maximum suppliers.
SELECT Country FROM supplier
GROUP BY Country ORDER BY COUNT(CompanyName) DESC LIMIT 1;




-- Customers witout any order.
SELECT * FROM customer WHERE Id NOT IN (SELECT CustomerId FROM orders);





-- Top 5 country with max customers
SELECT Country, COUNT(*) count_of_customers
FROM customer GROUP BY Country
ORDER BY COUNT(*) DESC
LIMIT 5;




-- Country with max customers:
SELECT Country, COUNT(*) suppliers_count
FROM supplier GROUP BY Country ORDER BY COUNT(*) DESC;




-- highest selling product
SELECT p.Id, p.ProductName, count(oi.Quantity) as Quantity_of_product
FROM customer c
JOIN orders o ON c.Id = o.CustomerId
JOIN orderitem oi ON o.Id = oi.OrderId
JOIN product p ON oi.ProductId = p.Id
JOIN supplier s ON s.Id = p.SupplierId
GROUP BY oi.ProductId
ORDER BY count(oi.Quantity) DESC;





-- Arranging the product id, product name based on high demand by the customer.
SELECT p.id,  p.ProductName, count(oi.ProductId) order_counts
FROM customer c
JOIN orders o ON c.Id = o.CustomerId
JOIN orderitem oi ON o.Id = oi.OrderId
JOIN product p ON oi.ProductId = p.Id
JOIN supplier s ON s.Id = p.SupplierId
group by p.id, p.ProductName
order by order_counts DESC;




-- Display the number of orders delivered every year.
SELECT year(o.OrderDate) as Order_Year, count(o.OrderNumber) as order_delivered
FROM customer c
JOIN orders o ON c.Id = o.CustomerId
JOIN orderitem oi ON o.Id = oi.OrderId
JOIN product p ON oi.ProductId = p.Id
JOIN supplier s ON s.Id = p.SupplierId
GROUP BY Order_Year;




--  Calculating year-wise total revenue.
SELECT YEAR(OrderDate) AS Order_Year, SUM(TotalAmount) AS Total_count
FROM orders
GROUP BY Order_Year;




-- Displaying the customer details whose order amount is maximum including all his orders.
SELECT c.*
FROM customer c
JOIN orders o 	  ON c.Id = o.CustomerId
JOIN orderitem oi ON o.Id = oi.OrderId
JOIN product p 	  ON oi.ProductId = p.Id
JOIN supplier s   ON s.Id = p.SupplierId
GROUP BY c.Id ORDER BY sum(o.TotalAmount) DESC LIMIT 1;




-- Displaying total amount ordered by each customer from high to low.
SELECT c.*, sum(o.TotalAmount) as "TOTAL AMOUNT"
FROM customer c
JOIN orders o 	  ON c.Id = o.CustomerId
JOIN orderitem oi ON o.Id = oi.OrderId
JOIN product p 	  ON oi.ProductId = p.Id
JOIN supplier s   ON s.Id = p.SupplierId
GROUP BY c.Id ORDER BY sum(o.TotalAmount) ASC;





-- find out top 3 suppliers in terms of revenue generated by their products.
select s.Id as 'Supplier Id', s.CompanyName as Company, s.ContactName as Name, sum(oi.UnitPrice) as 'Revenue in Rs'
FROM customer c
JOIN orders o 	  ON c.Id = o.CustomerId
JOIN orderitem oi ON o.Id = oi.OrderId
JOIN product p 	  ON oi.ProductId = p.Id
JOIN supplier s   ON s.Id = p.SupplierId
group by s.Id, s.CompanyName
order by sum(oi.UnitPrice) desc
limit 3;





-- customer details who ordered more than 10 products in the single order

select c.*, count(*) as "Number of orders"
FROM customer c
JOIN orders o 	  ON c.Id = o.CustomerId
JOIN orderitem oi ON o.Id = oi.OrderId
JOIN product p 	  ON oi.ProductId = p.Id
JOIN supplier s   ON s.Id = p.SupplierId
group by oi.OrderId, c.Id
having count(*) > 10
;





-- product details with the ordered quantity size as 1.

select p.Id, oi.Quantity as ordered_qty
FROM customer c
JOIN orders o 	  ON c.Id = o.CustomerId
JOIN orderitem oi ON o.Id = oi.OrderId
JOIN product p 	  ON oi.ProductId = p.Id
JOIN supplier s   ON s.Id = p.SupplierId
where oi.Quantity = 1
;





-- companies which supplies products whose cost is above 100.

select distinct s.Id as 'Supplier Id', s.CompanyName as Company, s.ContactName as Name, p.ProductName as 'Product Name', p.UnitPrice as 'Price'
FROM customer c
JOIN orders o 	  ON c.Id = o.CustomerId
JOIN orderitem oi ON o.Id = oi.OrderId
JOIN product p 	  ON oi.ProductId = p.Id
JOIN supplier s   ON s.Id = p.SupplierId
where p.UnitPrice > 100
;





-- customer list who belongs to same city and country arrange with supplier in country wise.

SELECT 
c.Id as "Cust ID", c.FirstName as Cust_Name, c.LastName as Cust_Surname, s.Id as "Supplier's ID", 
s.CompanyName as "Company", s.ContactName as "Supplier Name", s.Country
FROM customer c
JOIN orders o 	  ON c.Id = o.CustomerId
JOIN orderitem oi ON o.Id = oi.OrderId
JOIN product p 	  ON oi.ProductId = p.Id
JOIN supplier s   ON s.Id = p.SupplierId
where c.Country = s.Country
;





/* 
Company sells the product at different discounted rates. 
Refer actual product price in product table and selling price in the order item table. 
Write a query to find out total amount saved in each order then display the orders from highest to lowest amount saved. 
*/

SELECT distinct p.Id, p.ProductName, p.UnitPrice Original_Price , oi.UnitPrice Selling_Price, p.UnitPrice - oi.UnitPrice Discount
FROM customer c
JOIN orders o 	  ON c.Id = o.CustomerId
JOIN orderitem oi ON o.Id = oi.OrderId
JOIN product p 	  ON oi.ProductId = p.Id
JOIN supplier s   ON s.Id = p.SupplierId
order by Discount DESC
;




-- List few products that should be choose based on demand if someone wants to be a supplier and Who will be the competitors.

SELECT p.Id, p.ProductName, count(oi.ProductId) demand, s.CompanyName as Competitor_Company, s.ContactName as Competitor_Name
FROM customer c
JOIN orders o 	  ON c.Id = o.CustomerId
JOIN orderitem oi ON o.Id = oi.OrderId
JOIN product p 	  ON oi.ProductId = p.Id
JOIN supplier s   ON s.Id = p.SupplierId
group by p.Id, p.ProductName
order by demand DESC
limit 10
;




-- Find out for which products, UK is dependent on other countries for the supply. List the countries which are supplying these products in the same list.

SELECT DISTINCT p.ProductName, s.Country
FROM customer c
JOIN orders o 	  ON c.Id = o.CustomerId
JOIN orderitem oi ON o.Id = oi.OrderId
JOIN product p 	  ON oi.ProductId = p.Id
JOIN supplier s   ON s.Id = p.SupplierId
WHERE (c.Country = "UK") and (s.Country != "UK")
;




-- List the current and previous order amount for each customers.

with orders as (SELECT *, rank() over(partition by CustomerId order by OrderDate desc) RANKED
FROM orders)

SELECT
	o1.CustomerId AS "Customer ID", 
	o1.OrderDate 	 AS "Date of Previous Order",
	o1.TotalAmount 	 AS "Previous Ordered Amount",
	o2.OrderDate 	 AS "Date of Current Order",
	o2.TotalAmount   AS "Current Ordered Amount"

FROM orders o1 JOIN orders o2 ON o1.CustomerId = o2.CustomerId

WHERE (o1.RANKED = 2) & (o2.RANKED = 1);





/* 
suppliers and total sales made by their products and write a query on this view to 
find out top 2 suppliers in each country by total sales done by the products.
*/

SELECT 
s.CompanyName as 'Company', s.ContactName as "Supplier Name", sum(o.TotalAmount) as "Total SALES",
RANK() OVER(ORDER BY sum(o.TotalAmount) DESC) as "RANKING"
FROM customer c
JOIN orders o 	  ON c.Id = o.CustomerId
JOIN orderitem oi ON o.Id = oi.OrderId
JOIN product p 	  ON oi.ProductId = p.Id
JOIN supplier s   ON s.Id = p.SupplierId

GROUP BY s.Id
;