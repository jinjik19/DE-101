--- sales and profit dynamic
select
	ROUND(SUM(sales), 2) as sum_sales_by_month,
	ROUND(SUM(profit), 2) as sum_profit_by_month,
from stg.order
group by order_date_year_month
order by order_date_year_month ASC
---

--- KPI
select
	ROUND(SUM(sales), 2) as total_sales,
	ROUND(SUM(profit), 2) as total_profit,
	ROUND(AVG(discount) * 100, 2) as avg_discount,
	ROUND((SUM(profit) / SUM(sales)) * 100, 2) as profit_ratio
from stg.order
---

--- sales and profit by categories
select
	category,
	ROUND(SUM(sales), 2) as total_sales,
	ROUND(SUM(profit), 2) as total_profit
from stg.order
group by category
---