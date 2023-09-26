create or replace external table ET_PC_POLICYUSERROLEASSIGN(
	CREATEUSERID NUMBER(38,0) AS (TO_NUMBER(GET($1, 'CreateUserID'))),
	PREVIOUSGROUPID NUMBER(38,0) AS (TO_NUMBER(GET($1, 'PreviousGroupID'))),
	PUBLICID VARCHAR(16777216) AS (CAST(GET($1, 'PublicID') AS VARCHAR(16777216))),
	ACTIVE BOOLEAN AS (CAST(GET($1, 'Active') AS BOOLEAN)),
	CLOSEDATE TIMESTAMP_NTZ(9) AS (CAST(GET($1, 'CloseDate') AS TIMESTAMP_NTZ(9))),
	BEANVERSION NUMBER(38,0) AS (TO_NUMBER(GET($1, 'BeanVersion'))),
	CREATETIME TIMESTAMP_NTZ(9) AS (CAST(GET($1, 'CreateTime') AS TIMESTAMP_NTZ(9))),
	RETIRED NUMBER(38,0) AS (TO_NUMBER(GET($1, 'Retired'))),
	ASSIGNEDBYUSERID NUMBER(38,0) AS (TO_NUMBER(GET($1, 'AssignedByUserID'))),
	ASSIGNEDGROUPID NUMBER(38,0) AS (TO_NUMBER(GET($1, 'AssignedGroupID'))),
	POLICYID NUMBER(38,0) AS (TO_NUMBER(GET($1, 'PolicyID'))),
	UPDATEUSERID NUMBER(38,0) AS (TO_NUMBER(GET($1, 'UpdateUserID'))),
	COMMENTS VARCHAR(16777216) AS (CAST(GET($1, 'Comments') AS VARCHAR(16777216))),
	ASSIGNEDUSERID NUMBER(38,0) AS (TO_NUMBER(GET($1, 'AssignedUserID'))),
	PREVIOUSQUEUEID NUMBER(38,0) AS (TO_NUMBER(GET($1, 'PreviousQueueID'))),
	UPDATETIME TIMESTAMP_NTZ(9) AS (CAST(GET($1, 'UpdateTime') AS TIMESTAMP_NTZ(9))),
	ROLE NUMBER(38,0) AS (TO_NUMBER(GET($1, 'Role'))),
	ID NUMBER(38,0) AS (TO_NUMBER(GET($1, 'ID'))),
	ASSIGNMENTDATE TIMESTAMP_NTZ(9) AS (CAST(GET($1, 'AssignmentDate') AS TIMESTAMP_NTZ(9))),
	PREVIOUSUSERID NUMBER(38,0) AS (TO_NUMBER(GET($1, 'PreviousUserID'))),
	ASSIGNEDQUEUEID NUMBER(38,0) AS (TO_NUMBER(GET($1, 'AssignedQueueID'))),
	ASSIGNMENTSTATUS NUMBER(38,0) AS (TO_NUMBER(GET($1, 'AssignmentStatus'))))
location=@CSVLOADING/
auto_refresh=false
pattern='.*dbo_PC_POLICYUSERROLEASSIGN_.*'
file_format=(TYPE=PARQUET NULL_IF=())
;