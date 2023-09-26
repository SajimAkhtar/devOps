create or replace view MONTHLY_SALES(
	MONTH,
	TOTAL_SALES
) as
SELECT EXTRACT(MONTH, sale_date) AS month, SUM(quantity) AS total_sales
FROM sales
GROUP BY month;