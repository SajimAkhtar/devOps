create or replace secure view SHARED_VIEW(
	NAME,
	VALUE
) as
SELECT name, value
FROM et_pctl_accountcontactrole
WHERE s_en_us>10;