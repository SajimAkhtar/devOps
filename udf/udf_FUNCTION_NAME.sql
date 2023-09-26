CREATE OR REPLACE FUNCTION "FUNCTION_NAME"("X" NUMBER(38,0), "Y" NUMBER(38,0))
RETURNS NUMBER(38,0)
LANGUAGE JAVA
HANDLER = 'HandlerClass.handlerMethod'
TARGET_PATH = '@~/HandlerCode.jar'
AS '
      class HandlerClass {
          public static int handlerMethod(int x, int y) {
            return x + y;
          }
      }
  ';