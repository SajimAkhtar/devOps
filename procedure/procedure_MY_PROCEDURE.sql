CREATE OR REPLACE PROCEDURE "MY_PROCEDURE"()
RETURNS VARCHAR(16777216)
LANGUAGE JAVASCRIPT
EXECUTE AS CALLER
AS '
    // Your JavaScript code here
    return "Procedure executed successfully";
  ';