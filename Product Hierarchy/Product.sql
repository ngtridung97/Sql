/* Assume that we have a sample transaction table look like this.

item|category|
----|--------|
   1|      18|
   2|       7|
   3|      14|
   4|       3|
   5|       3|
   6|     267|
   7|     112|
   8|     112|
  --		--
 295|     290|
 296|     294|

Sample description:

    - item: child node, each item has multiple mother nodes.
    - category: the item's direct mother node.

The Manager wants to view the product hierarchy for all items. */

-- Recursive CTE

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


-- Iterative Loop

create table #item_recursive (

	item int not null,
	category int not null,
	lvl int not null
	
	)

--create clustered index tempindex on #item_recursive(item, category);
 
declare @lvl int;
set @lvl = 0;  
 
insert into #item_recursive(item, category, lvl)

select item, category, @lvl

from test.dbo.item;

while @lvl < 5 

	begin
		
		set @lvl = @lvl + 1;
		
		insert into #item_recursive(item,lvl,category)
			
			select s.item, c.category, @lvl
			
			from #item_recursive s
			
			inner join test.dbo.item c
			
			on s.lvl = @lvl - 1 and s.category = c.item
			
			where s.category <> c.category
			
	end

select *

from #item_recursive

order by item, lvl;