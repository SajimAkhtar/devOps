CREATE OR REPLACE PROCEDURE "DW_LOAD"("PROCESS_ID" FLOAT, "RUN_TYPE" VARCHAR(16777216), "LOAD_TYPE" VARCHAR(16777216), "SCD" VARCHAR(16777216))
RETURNS VARIANT
LANGUAGE JAVASCRIPT
EXECUTE AS CALLER
AS '
try
{
   var processid = PROCESS_ID;
   var runtype = RUN_TYPE;
   var loadtype = LOAD_TYPE;
   var scdtype = SCD;
   if (runtype == ''ALL'' && loadtype == ''FULL'')
   {
       var selquery = `select TABLE_NAME, TABLE_TYPE, AGG_LVL from metadata_ia where load_type = ''FULL'';`
       var gettb = snowflake.createStatement({sqlText: selquery});
       var towhile = gettb.execute();
       while(towhile.next())
       {
            processid = processid + 1;
            var tablename = towhile.getColumnValue(''TABLE_NAME'');
            var tabletype = towhile.getColumnValue(''TABLE_TYPE'');
            var aggrlevel = towhile.getColumnValue(''AGG_LVL'');
            if(tabletype == ''DIM'')
            {
                var stmt = snowflake.createStatement({sqlText: ''CALL DW_DIM_FULL(:1, :2, :3)'',
                binds: [processid, tablename, loadtype]});
                var result = stmt.execute();
            }
            else if(tabletype == ''FACT'')
            {
                var stmt = snowflake.createStatement({sqlText: ''CALL DW_FACT_FULL(:1, :2, :3)'',
                binds: [processid, tablename, loadtype]});
                var result = stmt.execute();
            }
            else if(tabletype == ''AGGR'')
            {
                var stmt = snowflake.createStatement({sqlText: ''CALL DW_FACT_AGG(:1, :2, :3, :4)'',
                binds: [processid, tablename, aggrlevel, loadtype]});
                var result = stmt.execute();
            }
            else
            {
                return "invalid argument";
            }
       }
       
   }
   else if (runtype == ''ALL'' && loadtype == ''INCR'') 
   {
       var selquery = `select TABLE_NAME, TABLE_TYPE, AGG_LVL from metadata_ia where load_type = ''INCR'' and SCD_TYPE = ?;`
       var gettb = snowflake.createStatement({sqlText: selquery, binds:[scdtype]});
       var towhile = gettb.execute();
       while(towhile.next())
       {
            processid = processid + 1;
            var tablename = towhile.getColumnValue(''TABLE_NAME'');
            var tabletype = towhile.getColumnValue(''TABLE_TYPE'');
            var aggrlevel = towhile.getColumnValue(''AGG_LVL'');
            if(tabletype == ''DIM'')
            {
                var stmt = snowflake.createStatement({sqlText: ''CALL DW_DIM_INCR(:1, :2, :3, :4)'',
                binds: [processid, tablename, scdtype, loadtype]});
                var result = stmt.execute();
            }
            else if(tabletype == ''FACT'')
            {
                var stmt = snowflake.createStatement({sqlText: ''CALL DW_FACT_INCR(:1, :2, :3, :4)'',
                binds: [processid, tablename, scdtype, loadtype]});
                var result = stmt.execute();
            }
            else
            {
                return "invalid argument";
            }
       }
   }
   else if (runtype == ''DIMFACT'' && loadtype == ''FULL'') 
   {
       var selquery = `select TABLE_NAME, TABLE_TYPE from metadata_ia where load_type = ''FULL'';`
       var gettb = snowflake.createStatement({sqlText: selquery});
       var towhile = gettb.execute();
       while(towhile.next())
       {
            processid = processid + 1;
            var tablename = towhile.getColumnValue(''TABLE_NAME'');
            var tabletype = towhile.getColumnValue(''TABLE_TYPE'');
            if(tabletype == ''DIM'')
            {
                var stmt = snowflake.createStatement({sqlText: ''CALL DW_DIM_FULL(:1, :2, :3)'',
                binds: [processid, tablename, loadtype]});
                var result = stmt.execute();
            }
            else if(tabletype == ''FACT'')
            {
                var stmt = snowflake.createStatement({sqlText: ''CALL DW_FACT_FULL(:1, :2, :3)'',
                binds: [processid, tablename, loadtype]});
                var result = stmt.execute();
            }
            else
            {
                return "invalid argument";
            }
       }
   }
   else if (runtype == ''DIMFACT'' && loadtype == ''INCR'') 
   {
		var selquery = `select TABLE_NAME, TABLE_TYPE, AGG_LVL from metadata_ia where load_type = ''INCR'' and SCD_TYPE = ?;`
		var gettb = snowflake.createStatement({sqlText: selquery, binds:[scdtype]});
		var towhile = gettb.execute();
		while(towhile.next())
		{	
			processid = processid + 1;
            var tablename = towhile.getColumnValue(''TABLE_NAME'');
            var tabletype = towhile.getColumnValue(''TABLE_TYPE'');
            var aggrlevel = towhile.getColumnValue(''AGG_LVL'');
            if(tabletype == ''DIM'')
            {
                var stmt = snowflake.createStatement({sqlText: ''CALL DW_DIM_INCR(:1, :2, :3, :4)'',
                binds: [processid, tablename, scdtype, loadtype]});
                var result = stmt.execute();
            }
            else if(tabletype == ''FACT'')
            {
                var stmt = snowflake.createStatement({sqlText: ''CALL DW_FACT_INCR(:1, :2, :3, :4)'',
                binds: [processid, tablename, scdtype, loadtype]});
                var result = stmt.execute();
            }
            else
            {
                return "invalid argument";
            }
		}
   } 
   else if (runtype == ''DIM'' && loadtype == ''FULL'') 
   {
        var selquery = `select TABLE_NAME, TABLE_TYPE from metadata_ia where load_type = ''FULL'' and table_type = ''DIM'';`
		var gettb = snowflake.createStatement({sqlText: selquery});
		var towhile = gettb.execute();
		while(towhile.next())
		{
			processid = processid + 1;
			var tablename = towhile.getColumnValue(''TABLE_NAME'');
			var stmt = snowflake.createStatement({sqlText: ''CALL DW_DIM_FULL(:1, :2, :3)'',
					binds: [processid, tablename, loadtype]});
			var result = stmt.execute();
		}
   } 
   else if (runtype == ''DIM'' && loadtype == ''INCR'') 
   {
		var selquery = `select TABLE_NAME, TABLE_TYPE, AGG_LVL from metadata_ia where load_type = ''INCR'' and table_type = ''DIM'' and SCD_TYPE = ?;`
        var gettb = snowflake.createStatement({sqlText: selquery, binds:[scdtype]});
		var towhile = gettb.execute();
		while(towhile.next())
		{
			processid = processid + 1;
			var tablename = towhile.getColumnValue(''TABLE_NAME'');
			var stmt = snowflake.createStatement({sqlText: ''CALL DW_DIM_INCR(:1, :2, :3, :4)'',
					binds: [processid, tablename, scdtype, loadtype]});
			var result = stmt.execute();
		}
   }
   else if (runtype == ''FACT'' && loadtype == ''FULL'') 
   {
		var selquery = `select TABLE_NAME, TABLE_TYPE from metadata_ia where load_type = ''FULL'' and table_type = ''FACT'';`
		var gettb = snowflake.createStatement({sqlText: selquery});
		var towhile = gettb.execute();
		while(towhile.next())
		{
			processid = processid + 1;
			var tablename = towhile.getColumnValue(''TABLE_NAME'');
			var stmt = snowflake.createStatement({sqlText: ''CALL DW_DIM_FULL(:1, :2, :3)'',
					binds: [processid, tablename, loadtype]});
			var result = stmt.execute();
		}
   }
   else if (runtype == ''FACT'' && loadtype == ''INCR'') 
   {
		var selquery = `select TABLE_NAME, TABLE_TYPE, AGG_LVL from metadata_ia where load_type = ''INCR'' and table_type = ''FACT'' and SCD_TYPE = ?;`
        var gettb = snowflake.createStatement({sqlText: selquery, binds:[scdtype]});
		var towhile = gettb.execute();
		while(towhile.next())
		{
		processid = processid + 1;
			var tablename = towhile.getColumnValue(''TABLE_NAME'');
			var stmt = snowflake.createStatement({sqlText: ''CALL DW_FACT_INCR(:1, :2, :3, :4)'',
					binds: [processid, tablename, scdtype, loadtype]});
			var result = stmt.execute();
		}
   }
   else if (runtype == ''AGG'' && loadtype == ''FULL'') 
   {
		var selquery = `select TABLE_NAME, TABLE_TYPE, AGG_LVL from metadata_ia where load_type = ''FULL'' and table_type = ''AGGR'';`
		var gettb = snowflake.createStatement({sqlText: selquery});
		var towhile = gettb.execute();
        var testpm = ''''
		while(towhile.next())
		{
			processid = processid + 1;
			var tablename = towhile.getColumnValue(''TABLE_NAME'');
			var aggrlevel = towhile.getColumnValue(''AGG_LVL'');
			var stmt = snowflake.createStatement({sqlText: ''CALL DW_FACT_AGG(:1, :2, :3, :4)'', 
            binds: [processid, tablename, aggrlevel, loadtype]});
			var result = stmt.execute();
            var testpm = testpm + tablename
		}
        return testpm;
   }
   else 
   {
		return "invalid type"
   }
}
catch(err) 
{
	resuloadtype =  "Failed: Code: " + err.code + "\\n  State: " + err.state;
	resuloadtype += "\\n  Message: " + err.message;
	resuloadtype += "\\nStack Trace:\\n" + err.stackTraceTxt; 
	snowflake.execute( {sqlText: " rollback;"} );
}
';