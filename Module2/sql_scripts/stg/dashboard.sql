--- sales and profit dynamic
select
	TO_CHAR(order_date, 'YYYY-MM') as order_date_year_month,
	ROUND(SUM(sales), 2) as sum_sales_by_month,
	ROUND(SUM(profit), 2) as sum_profit_by_month
from stg.order
group by order_date_year_month
order by order_date_year_month ASC;
---

--- KPI
select
	ROUND(SUM(sales), 2) as total_sales,
	ROUND(SUM(profit), 2) as total_profit,
	ROUND(AVG(discount) * 100, 2) as avg_discount,
	ROUND((SUM(profit) / SUM(sales)) * 100, 2) as profit_ratio
from stg.order;
---

--- sales and profit by categories
select
	category,
	ROUND(SUM(sales), 2) as total_sales,
	ROUND(SUM(profit), 2) as total_profit
from stg.order
group by category;
---

---sales by customer
select
	customer_id,
	customer_name,
	ROUND(SUM(sales), 2) as total_sales
from stg.order
group by customer_id, customer_name
order by customer_id ASC;
---

---avg sales by customer
select
	customer_id,
	customer_name,
	ROUND(AVG(sales), 2) as avg_sales
from stg.order
group by customer_id, customer_name
order by customer_id ASC;
---

--- sales and profit by manager
select
	p.person,
	ROUND(SUM(o.sales), 2) as total_sales,
	ROUND(SUM(o.profit), 2) as total_profit
from stg.order o
inner join stg.people p USING(region)
group by p.person
order by p.person;
---

--- sales by segment
select
	segment,
	ROUND(SUM(sales), 2) as total_sales
from stg.order
group by segment;
---

--- sales by region
select
	region,
	ROUND(SUM(sales), 2) as total_sales
from stg.order
group by region;
---

--- sales by state
select
	state,
	ROUND(SUM(sales), 2) as total_sales
from stg.order
group by state
order by total_sales;
---

--- returned orders
with returned_status as (
	select
		distinct order_id,
		case 
			when r.returned is null then 'NO'
			else 'YES'
		end as returned
	from stg.order o
	left join stg.return r using(order_id)
	order by order_id
)
select
	ROUND(
		(COUNT(distinct order_id) filter (where returned = 'YES') / 
		COUNT(distinct order_id)::DECIMAL) * 100, 2
	) as returned_orders
from returned_status
---


--- top 10 customers by sales
select 
    ROW_NUMBER() OVER(order by sum(sales) desc) as rank,
    customer_id,
    ROUND(SUM(sales), 2) AS sales
from stg.order 
group by customer_id
limit 10;
---