In daily work, we might need to store the hierarchy data with minimum memory solutions. However, we also want to go a full view of the hierarchy table, with its details as well as without storing too much information in the raw data. That's the concept, now we should start with an example.

**Features:**
+ Database: [SQL Server Developer 2019 64-bit](https://www.microsoft.com/en-us/sql-server/sql-server-downloads)
+ Dataset: [SampleItem.csv](https://github.com/ngtridung97/Sql/blob/master/Product%20Hierarchy/SampleItem.csv)
+ Sample Script: [Product.sql](https://github.com/ngtridung97/Sql/blob/master/Product%20Hierarchy/Product.sql)

See how it works below

### Recursive CTE
----------
We would like to present the product hierarchy for all items, but the raw data just allows us to check the closest node of each SKU, not all the higher-level nodes. [Recursive](https://www.sqlservertutorial.net/sql-server-basics/sql-server-recursive-cte/) query is a popular solution for this situation.

**The concept**
```sql
WITH expression_name (column_list)
AS
(
    -- Anchor member
    initial_query  
    UNION ALL
    -- Recursive member that references expression_name.
    recursive_query  
)
-- references expression name
SELECT *
FROM expression_name
```

**Our code**
```sql		
with

	item_recursive as (
	
		select item, category, 0 as lvl
        
		from test.dbo.item
		
		union all
		
		select t1.item, t1.category, t2.lvl + 1
		
		from test.dbo.item t1
		
		inner join item_recursive t2
		
		on t2.category = t1.item
		
	)
		
select *

from item_recursive

order by item, lvl

option (maxrecursion 0);
```

### Iterative Loop
----------
Personally, I don't like the first method due to its performance. Lucky for us, Recursive is not the only way to meet our demand. By using [Iterative loop](https://en.wikipedia.org/wiki/For_loop#:~:text=In%20computer%20science%2C%20a%20for,code%20to%20be%20executed%20repeatedly.&text=A%20for%2Dloop%20has%20two,is%20executed%20once%20per%20iteration.), the performance of this second approach is better.

Or maybe in this data set, the number of cate_lvl is small (3) and I guess with that number of nodes, it's not big enough to take the final quote.

**Temp table**
```sql
create table #item_recursive (

	item int not null,
	category int not null,
	lvl int not null
	
	);
```

**Iterative loop**
```sql 
declare @lvl int;
set @lvl = 0;  
 
insert into #item_recursive(item, category, lvl)

select item, category, @lvl

from test.dbo.item;

while @lvl < 5 

	begin
		
		set @lvl = @lvl + 1;
		
			insert into #item_recursive(item,lvl,category)
			
			select s.item, @lvl, c.category
			
			from #item_recursive  s
			
			inner join test.dbo.item  c
			
			on s.lvl = @lvl -1 and s.category = c.item
			
			where s.category <> c.category
			
	end

select *

from #item_recursive

order by item, lvl;
```

### Result
----------
item|category|lvl|
----|--------|---|
   1|      18|  0|
   1|      23|  1|
   1|     112|  2|
   2|       7|  0|
   2|     112|  1|
   3|      14|  0|
   3|     112|  1|
   4|       3|  0|
   4|      14|  1|
   4|     112|  2|
   5|       3|  0|
   5|      14|  1|
   5|     112|  2|
   6|     267|  0|
   6|       3|  1|
   6|      14|  2|
   6|     112|  3|

### Feedback & Suggestions
----------
Please feel free to fork, comment or give feedback to ng.tridung97@gmail.com