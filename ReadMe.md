## Select records from table without writing the columns names

This stored procedure helps to retrieve the records from a table without writing columns names inside the stored procedure.

## How it was made
- create the procedure and give it a name
- integrate some checks to make sure the schema and table name were provided; if one of these two parameters haven't been provided the store procedure will return a message
- start composing the cursor which will go through the system table (INFORMATION_SCHEMA.COLUMNS); it will take the columns name based on the schema and table name that we send using the stored procedure parameters
- inside the cursor i will add each column name to the variable that will contains the whole select statement (@qry)
- after the cursor was closed and deallocated i add the from and where clause 
- in the end i execute the @qry variable which contains the select statement

## Execution syntax
exec Json_Select @schema_name = 'your schema name', @table='your table name', @condition = 'your condition' (based on this you'll retrieve specific records)


!! This stored procedure can only be used if you want to retrieve all the columns in a table !!
