create or replace secure view SECURE_SALES(
	SALES_ID,
	PRODUCT_NAME,
	SALE_DATE
) as
SELECT sales_id, product_name, sale_date
FROM sales
WHERE CURRENT_ROLE() IN ('MANAGER', 'ADMIN');