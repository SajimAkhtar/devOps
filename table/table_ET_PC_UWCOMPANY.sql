create or replace external table ET_PC_UWCOMPANY(
	CREATEUSERID NUMBER(38,0) AS (TO_NUMBER(GET($1, 'CreateUserID'))),
	PUBLICID VARCHAR(16777216) AS (CAST(GET($1, 'PublicID') AS VARCHAR(16777216))),
	BEANVERSION NUMBER(38,0) AS (TO_NUMBER(GET($1, 'BeanVersion'))),
	RETIRED NUMBER(38,0) AS (TO_NUMBER(GET($1, 'Retired'))),
	CREATETIME TIMESTAMP_NTZ(9) AS (CAST(GET($1, 'CreateTime') AS TIMESTAMP_NTZ(9))),
	NAME VARCHAR(16777216) AS (CAST(GET($1, 'Name') AS VARCHAR(16777216))),
	CODE NUMBER(38,0) AS (TO_NUMBER(GET($1, 'Code'))),
	UPDATEUSERID NUMBER(38,0) AS (TO_NUMBER(GET($1, 'UpdateUserID'))),
	STATE NUMBER(38,0) AS (TO_NUMBER(GET($1, 'State'))),
	STATUS NUMBER(38,0) AS (TO_NUMBER(GET($1, 'Status'))),
	PARENTNAME VARCHAR(16777216) AS (CAST(GET($1, 'ParentName') AS VARCHAR(16777216))),
	UPDATETIME TIMESTAMP_NTZ(9) AS (CAST(GET($1, 'UpdateTime') AS TIMESTAMP_NTZ(9))),
	NAICCODE VARCHAR(16777216) AS (CAST(GET($1, 'NAICCode') AS VARCHAR(16777216))),
	ID NUMBER(38,0) AS (TO_NUMBER(GET($1, 'ID'))))
location=@CSVLOADING/
auto_refresh=false
pattern='.*dbo_PC_UWCOMPANY_.*'
file_format=(TYPE=PARQUET NULL_IF=())
;