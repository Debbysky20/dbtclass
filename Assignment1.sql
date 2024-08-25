CREATE OR REPLACE DATABASE mydatabase;

CREATE OR REPLACE TEMPORARY TABLE mycsvtable (
     id INTEGER,
     last_name STRING,
     first_name STRING,
     company STRING,
     email STRING,
     workphone STRING,
     cellphone STRING,
     streetaddress STRING,
     city STRING,
     postalcode STRING);

CREATE OR REPLACE TEMPORARY TABLE myjsontable (
     json_data VARIANT);

CREATE OR REPLACE WAREHOUSE mywarehouse WITH
     WAREHOUSE_SIZE='X-SMALL'
     AUTO_SUSPEND = 120
     AUTO_RESUME = TRUE
     INITIALLY_SUSPENDED=TRUE;

CREATE OR REPLACE FILE FORMAT mycsvformat
   TYPE = 'CSV'
   FIELD_DELIMITER = '|'
   SKIP_HEADER = 1;

 CREATE OR REPLACE FILE FORMAT myjsonformat
  TYPE = 'JSON'
  STRIP_OUTER_ARRAY = TRUE;  

  CREATE OR REPLACE STAGE my_csv_stage
  FILE_FORMAT = mycsvformat
  URL = 's3://snowflake-docs';

  CREATE OR REPLACE STAGE my_json_stage
  FILE_FORMAT = myjsonformat
  URL = 's3://snowflake-docs';

COPY INTO mycsvtable
  FROM @my_csv_stage/tutorials/dataloading/contacts1.csv
  ON_ERROR = 'skip_file';

  COPY INTO mycsvtable
  FROM @my_csv_stage/tutorials/dataloading/
  PATTERN='.*contacts[1-5].csv'
  ON_ERROR = 'skip_file';

  CREATE OR REPLACE TABLE save_copy_errors AS SELECT * FROM TABLE(VALIDATE(mycsvtable, JOB_ID=>'<01b6964d-0000-c8b2-0000-0000bf5db4e9>'));

  SELECT * FROM SAVE_COPY_ERRORS;

  SELECT * FROM mycsvtable;

  SELECT * FROM myjsontable;

  DROP DATABASE IF EXISTS mydatabase;
DROP WAREHOUSE IF EXISTS mywarehouse;