--- KPI
select
	TO_CHAR(order_date, 'YYYY-MM') as order_date_year_month,
	ROUND(SUM(sales), 2) as sum_sales_by_month,
	ROUND(SUM(profit), 2) as sum_profit_by_month,
	ROUND(AVG(discount) * 100, 2) as avg_discount_by_month,
	ROUND((SUM(profit) / SUM(sales)) * 100, 2) as profit_ration_by_month
from stg.order
group by order_date_year_month
order by order_date_year_month ASC
---