create or replace materialized view MATERIALIZED_VIEW(
	NAME,
	AGE
) as
SELECT * FROM PERMANENT_TABLE;