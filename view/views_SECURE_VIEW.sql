create or replace secure view SECURE_VIEW(
	NAME,
	AGE
) as
SELECT * FROM PERMANENT_TABLE;