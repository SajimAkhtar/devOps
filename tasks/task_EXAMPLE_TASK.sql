create or replace task EXAMPLE_TASK
	warehouse=COMPUTE_WH
	schedule='USING CRON 0 0 * * * UTC'
	as INSERT INTO CUSTOMERS
  SELECT * FROM CUSTOMERS;