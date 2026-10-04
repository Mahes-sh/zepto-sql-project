drop table if exists zepto;

create table zepto (
sku_id SERIAL PRIMARY KEY,
category VARCHAR(120),
name VARCHAR(150) NOT NULL,
mrp NUMERIC(8,2),
discountPercent NUMERIC(5,2),
availableQuantity INTEGER,
discountedSellingPrice NUMERIC(8,2),
weightInGms INTEGER,
outOfStock BOOLEAN,	
quantity INTEGER

-- data exploration

--count of rows
select count(*) from zepto;

--sample data 
select * from zepto 
limit 10;

-- null values 

select * from zepto 
where name is null
or 
category is null 
or 
mrp is null 
or 
discountPercent is null 
or 
availableQuantity is null 
or 
discountedSellingPrice is null 
or 
weightInGms is null 
or 
outOfStock is null
or
quantity is null


--diffrent product category

Select distinct category
from zepto 
order by category;

--product in stock vs out of stock

select outofstock,count(sku_id) from  zepto
group by outofstock;

--product names present multiple time

select name,count(sku_id) as "Number of SKUs"  from zepto
group by name
having count(sku_id) > 1
order by count(sku_id) desc;

-- data cleaning

--product with price = 0

select * from zepto
where mrp = 0 or discountedSellingPrice = 0;

Delete from zepto
where mrp = 0 ;

update zepto 
set mrp = mrp/100.0,
discountedSellingPrice = discountedSellingPrice/100.0;

-- data analysis

-- Q1. Find the top 10 best-value products based on the discount percentage.

select name,mrp,discountpercent 
from zepto
order by discountpercent desc
limit 10; 

--Q2.What are the Products with High MRP but Out of Stock

select distinct name,mrp,outOfStock  from zepto
where  outOfStock = True and mrp >300
order by mrp desc;

---Q3.Calculate Estimated Revenue for each category

select category,sum(discountedSellingPrice*availableQuantity) as total_revenue 
from zepto
group by category 
order by total_revenue Desc ;

--Q4.Find all products where MRP is greater than ₹500 and discount is less than 10%.

select distinct name,mrp,discountPercent
from zepto
where mrp >500 and discountPercent < 10
order by mrp desc,discountPercent desc;

--Q5.Identify the top 5 categories offering the highest average discount percentage.

select category,
Round(avg(discountPercent),2) as avg_discount from zepto 
group by category
order by avg(discountPercent) Desc limit 5 ;

-- Q6. Find the price per gram for products above 100g and sort by best value.

select Distinct name,weightInGms,discountedSellingPrice,Round((discountedSellingPrice/weightInGms),2) as price_per_gram
from zepto
where weightInGms >= 100 
order by price_per_gram ;


--Q7.Group the products into categories like Low, Medium, Bulk.

select distinct name,weightInGms,
case
when weightInGms < 1000 then 'Low'
when weightInGms <5000 then 'Medium'
else 'Bulk'
end as weight_category
from zepto;

--Q8.What is the Total Inventory Weight Per Category 

select category,sum(weightInGms * availableQuantity) as Total_weight
from zepto
group by category
order by Total_weight;


































