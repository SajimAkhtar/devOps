CREATE OR REPLACE PROCEDURE "DW_FACT_FULL"("PROCESSID" FLOAT, "TABLE_NAME" VARCHAR(16777216), "LOAD_TYPE" VARCHAR(16777216))
RETURNS VARCHAR(16777216)
LANGUAGE JAVASCRIPT
EXECUTE AS OWNER
AS '
var result = '''';
var tblname = TABLE_NAME;
var ldtype = LOAD_TYPE;
var jobname = "DATALOAD_" + ldtype + "_" + tblname;
try {
    var db_stmt = `select TABLE_CATALOG, TABLE_SCHEMA from INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = ?;`
    var sf_db_stmt = snowflake.createStatement({sqlText: db_stmt ,binds : [TABLE_NAME]});
    var exe_sf_db_stmt = sf_db_stmt.execute();
    exe_sf_db_stmt.next();
    var dbase = exe_sf_db_stmt.getColumnValue(''TABLE_CATALOG'');
    var sname = exe_sf_db_stmt.getColumnValue(''TABLE_SCHEMA'');
    
	var ins_stmt = `INSERT INTO ETL.dw_control_table (processid,machine_name,job_name,source_type,source_name,is_enabled,target_type,         target_db,target_schema,target_name,execution_frequency,job_start_time,job_end_time,JOB_STATUS,
    TARGET_TABLE) values (?,''SNOWFLAKE'',?,''SQLSERVER'',''POLICYCENTER_DB'',''1'',''CLOUD'',?,?,''SNOWFLAKE'',
    ''DAILY'', CURRENT_TIMESTAMP,CURRENT_TIMESTAMP,''STARTED'',?);`
	var sf_ins_stmt = snowflake.createStatement({sqlText: ins_stmt,binds : [PROCESSID,jobname,dbase,sname,tblname]});
	var exec_sf_ins_stmt = sf_ins_stmt.execute();

    
	var v_stmt = `select sql_query from ETL.METADATA_IA where TABLE_NAME = ? AND LOAD_TYPE = ? ;`
	var sf_stmt = snowflake.createStatement({sqlText: v_stmt, binds : [TABLE_NAME,LOAD_TYPE]});
	var exe_sf_stmt = sf_stmt.execute();       
	exe_sf_stmt.next();       
	var sqlquery1 = exe_sf_stmt.getColumnValue(1);
	var sf_query = snowflake.createStatement({sqlText: sqlquery1});
	var v_load = sf_query.execute();
    var row_inst = sf_query.getNumRowsInserted();
    var row_updt = sf_query.getNumRowsUpdated();
    
  
    var ins_success_stmt = `update ETL.dw_control_table set JOB_STATUS =''SUCCESS'',ROWS_INSERTED = ? ,ROWS_UPDATED=? where processid = ? and TARGET_TABLE = ?;`
	var sf_ins_success_stmt = snowflake.createStatement({sqlText: ins_success_stmt,binds : [row_inst,row_updt,PROCESSID,TABLE_NAME]});
	var exec_sf_ins_success_stmt = sf_ins_success_stmt.execute();

    
}
catch(err) 
{
	result =  "Failed: Code: " + err.code + "\\n  State: " + err.state;
	result += "\\n  Message: " + err.message;
	result += "\\nStack Trace:\\n" + err.stackTraceTxt; 
	snowflake.execute( {sqlText: " rollback;"} );

	var ins_fail_stmt = `update etl.dw_control_table set job_status =''FAILURE''  
	where target_name = ?;`
	var sf_ins_fail_stmt = snowflake.createStatement({sqlText: ins_fail_stmt,binds : [TABLE_NAME]});
	var exec_sf_ins_fail_stmt = sf_ins_fail_stmt.execute();  

	var ins_err_stmt = ''insert into etl.dw_control_table (error_message) values (?);''
	var sf_ins_err_stmt = snowflake.createStatement({sqlText:ins_err_stmt, binds:[err.message]})
	var exe_sf_ins_err_stmt = sf_ins_err_stmt.execute();
}

return row_inst ;
end;
';