use sql_project1;

-- SQL Retail Sales Analysis

-- Create table
drop table if exists retail_sales;
CREATE TABLE retail_sales
(
    transactions_id INT PRIMARY KEY,
    sale_date DATE,	
    sale_time TIME,
    customer_id INT,	
    gender VARCHAR(10),
    age INT,
    category VARCHAR(35),
    quantity INT,
    price_per_unit FLOAT,	
    cogs FLOAT,
    total_sale FLOAT
);
drop table retail_sales;

select * from retail_sales;

select count(*) from retail_sales;

-- Null values--

select * from retail_sales
where 
	transactions_id is null or sale_date is null or sale_time is null
        or customer_id is null or gender is null or age is null
        or category is null or quantity is null or price_per_unit is null 
	or cogs is null or total_sale is null;
        
-- Delete row--
delete from retail_sales
where 
	transactions_id is null or sale_date is null or sale_time is null
        or customer_id is null or gender is null or age is null
        or category is null or quantity is null or price_per_unit is null
        or cogs is null or total_sale is null;

-- Data Exploration --
-- How many sales we have--

select count(*) as total_Sale from retail_sales;

-- How many unique customer we have?

select count(distinct customer_id) as Total_Customer from retail_sales;

-- How many category we have?--

select distinct category from retail_sales;

-- Data Analysis & Business Key Problem & Answer --

 -- Que - 1 Retrive all column for sales made on '2022-11-05'
 
 select *
 from retail_sales
 where sale_date ='2022-11-05';
 
 -- Que- 2 Retrive all transaction where the category is 'clothing' and the quantity sold is more than 4 the month of mar-2022
 
select category, sum(quantity)
from retail_sales
where category ='Clothing'
group by 1;


select * 
from retail_sales
where 
category ='Clothing'
and
to_char(sale_date, 'YYYY-MM') = '2022-06'
and 
quantity >=4;

-- Question 3: Ralculate thr total sales for each category--

select 
   	category,
	sum(total_sale) as net_sale,
	count(*) as total_oeders
from retail_sales
group by 1;



-- Question 4: Average age of customer who purchased item the 'Beauty' category --

select 
	round (avg(age),2) as avg_age
from retail_sales
where category='Beauty';


-- Question 5: Find all the transaction where total_sale is greater than 1000--

select * from retail_sales
where total_sale > 1000;


-- Question 6: Find the total nuber of transaction(transactipn_id) made by each gender in each category --

select 
	category,
    gender,
    count(*) as total_trans
from retail_sales
group by
	category,
    gender
order by 1;

-- Question 7: Calculate the average sale for each month , find out best selling month in each year --

select 
    year,
    month,
    avg_sale
from
(
select 
    extract(year from sale_date) as year,
    extract(month from sale_date) as month,
    avg(total_sale) as avg_sale,
    rank() over (partition by extract(year from sale_date) order by avg(total_sale) desc) as Rnk
from retail_sales
group by 1,2
) as t1
where Rnk = 1;

-- Question 8: Find top 5 customers bansed on the higesht total sales --

select 
    customer_id,
    sum(total_sale) as total_sales
from retail_sales
group by 1
order by 2 desc
limit 5;


-- Question 9: Find unique customer who purchased item from each category --

select 
    category,
    count(distinct customer_id) as count_unique_cs
from retail_sales
group by category;

-- Question 10: Crete each shift and number of ordes (Example Morning < 12, Afternoon Between 12 & 17, Evening >17) --


with hourly_sale
as
(
select *,
	case
	when extract(hour from sale_time) < 12 then 'Morning'
        when extract(hour from sale_time) between 12 and 17 then 'Afternoon'
        else 'Evening'
	end as shift
from retail_sales
)
select 
    shift,
    count(*) as total_orders
from hourly_sale
group by shift;


----------------- END OF PROJECT -------------
