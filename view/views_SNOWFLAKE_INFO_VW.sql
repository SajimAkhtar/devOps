create or replace view SNOWFLAKE_INFO_VW(
	OBJECT_TYPE,
	OBJECT_NAME,
	OBJECT_OWNER,
	CREATED,
	LAST_ALTERED
) as
WITH CTE_INFO AS
(select 
'DATABASE' as object_type,
database_name as object_name,
DATABASE_OWNER as object_owner,
CREATED as CREATED,
LAST_ALTERED as LAST_ALTERED
from snowflake.account_usage.databases
where deleted is null and object_name not in ('SNOWFLAKE','SNOWFLAKE_SAMPLE_DATA')
union
select 
'SCHEMA' as object_type,
schema_name as object_name,
SCHEMA_OWNER as object_owner,
CREATED as CREATED,
LAST_ALTERED as LAST_ALTERED
from snowflake.account_usage.schemata
where deleted is null
union
select 
'TABLE' as object_type,
table_name as object_name,
TABLE_OWNER as object_owner,
CREATED as CREATED,
LAST_ALTERED as LAST_ALTERED
from snowflake.account_usage.tables
where deleted is null
and table_type = 'BASE TABLE'
union
select 
'VIEW' as object_type,
table_name as object_name,
TABLE_OWNER as object_owner,
CREATED as CREATED,
LAST_ALTERED as LAST_ALTERED
from snowflake.account_usage.views
where deleted is null
union
select 
'STAGE' as object_type,
stage_name as object_name,
STAGE_OWNER as object_owner,
CREATED as CREATED,
LAST_ALTERED as LAST_ALTERED
from snowflake.account_usage.stages
where deleted is null
union
select 
'PIPE' as object_type,
pipe_name as object_name,
PIPE_OWNER as object_owner,
CREATED as CREATED,
LAST_ALTERED as LAST_ALTERED
from snowflake.account_usage.pipes
where deleted is null
union
select 
'FUNCTION_OR_SPROC' as object_type,
function_name as object_name,
FUNCTION_OWNER as object_owner,
CREATED as CREATED,
LAST_ALTERED as LAST_ALTERED
from snowflake.account_usage.functions
where deleted is null
union
select 
'FILE_FORMAT' as object_type,
file_format_name as object_name,
FILE_FORMAT_OWNER as object_owner,
CREATED as CREATED,
LAST_ALTERED as LAST_ALTERED
from snowflake.account_usage.file_formats
where deleted is null
order by object_type
)
SELECT * FROM CTE_INFO;