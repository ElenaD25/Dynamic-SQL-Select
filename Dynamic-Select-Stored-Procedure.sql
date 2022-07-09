ALTER proc SP_Dynamic_Select
@schema_name varchar(100), @table varchar(200), @condition varchar(max)
	as 
		begin
			declare
			@qry varchar(max) = 'select ',
			@FirstRow int = 1,
			@key varchar(max), 
			@val varchar(max),
			@type varchar(max),
			@column varchar(max)
			
		begin try 
			if(@schema_name is null or @schema_name = '')
			throw 50020, 'The schema name has not been provided', 1
			else if(@table is null or @table= '')
				throw 50030, 'The table name hasn''t been provided',1
			else

			declare db_cursor cursor local for
		select column_name from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = @table
			open db_cursor
				fetch next from db_cursor into @column

			while @@FETCH_STATUS = 0
				
				begin 
					if @FirstRow = 0
						set @qry= @qry + ', '
						set @qry =@qry + @column
						set @FirstRow = 0
					fetch next from db_cursor into @column
				end
			
		set @FirstRow = 1	
		close db_cursor
		deallocate db_cursor

set @qry = @qry + ' from [' + @schema_name + '].[' + @table +'] where ' + @condition
exec (@qry)
--print(@qry)
	end try
		begin catch
			select error_message() as message
		end catch

end