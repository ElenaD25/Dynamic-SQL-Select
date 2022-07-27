ALTER proc SP_Dynamic_Select
@schema_name nvarchar(100), @table nvarchar(200), @column_n nvarchar(300), @value nvarchar(max)
	as 
		begin
			declare
			@params nvarchar(max) , 
			@condition_test nvarchar(1000),
			@qry nvarchar(max) = N'select ',
			@FirstRow int = 1,
			@key varchar(max), s
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
						set @qry =@qry + trim(@column)
						set @FirstRow = 0
					fetch next from db_cursor into @column
				end
			
		set @FirstRow = 1	
		close db_cursor
		deallocate db_cursor

set @params= N'@vals nvarchar(1000)'
set @qry = @qry + ' from '+ quotename(trim(@schema_name)) + '.' + quotename(trim(@table))
set @qry = @qry + ' where ' + trim(@column_n) + ' = trim(@vals)'

	exec sp_executesql @qry, @params, @vals = @value

	end try
		begin catch
			select error_message() as message
		end catch

end 