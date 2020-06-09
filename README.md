Frequent SQL problems in my daily work. Please find attached file in each content for detail.

**Features:**
+ Database: [PostgreSQL 12.1 64-bit](https://www.postgresql.org/download/)

See how it works below

### Precheck Account Payable (AP)
----------

**Script**: [AP.sql](https://github.com/ngtridung97/Sql/blob/master/AP.sql)

```sql
```

### Do action A but no action B
----------

We wants to know which vendors have done action A but have not done action B, then sends them an email to promote action A (imagine A is better for us).

**First approach is using [NOT EXISTS](https://www.w3schools.com/sql/sql_exists.asp) and [Correlated Subquery](https://en.wikipedia.org/wiki/Correlated_subquery#:~:text=In%20a%20SQL%20database%20query,query%2C%20it%20can%20be%20slow.)**

```sql
select distinct vendor_num

from public.delivery a

where not exists(select *

	from public.delivery

	where vendor_num = a.vendor_num
	
	and delivery_method = 'DTV') -- Have not done Action B
	
and delivery_method = 'DTS'; -- Have done Action A
```

**Second approach is marking action B as 0 and the action A as 1. Vendors who have not done action B should have min value = 1**

```sql
with

	delivery_method_check as (select ref_num, vendor_num, delivery_method,
	
			case
			
			when delivery_method in ('DTS') then 1 -- Have done Action A
			
			when delivery_method = 'DTV' then 0 -- Have not done Action B
            
			else null 
     
     		end as delivery_method_check
     		
     	from public.delivery)
     		
select vendor_num

from delivery_method_check

group by vendor_num

having min(delivery_method_check) = 1;
```

**Script**: [Delivery.sql](https://github.com/ngtridung97/Sql/blob/master/Delivery.sql)

### Historical price change
----------

Suppose we need a date range record changes in invoice cost (NIC) overtime.

**First idea is MIN(), MAX() functions and GROUP BY**

```sql
select

	vendor_num, item_idnt, item_desc, min(doc_date) as min_doc_date, max(doc_date) as max_doc_date, inv_price
	
from public.invoice_detail

group by vendor_num, item_idnt, item_desc, inv_price;
```
This method cause the overlap in date range because of the repeat of some prices.

**Sencond approach is LAG() or LEAD() functions**

```sql
with

	source_table as (select vendor_num, item_idnt, item_desc, doc_date, inv_price,
		
			lag(inv_price) over(partition by vendor_num, item_idnt order by doc_date) as prev_inv_price,
			
			lag(doc_date) over(partition by vendor_num, item_idnt order by doc_date) as to_date
	
		from public.invoice_detail),
		
	max_doc_date as (select vendor_num, item_idnt, max(doc_date) as max_doc_date

		from public.invoice_detail	
	
		group by vendor_num, item_idnt),

	price_change as (select vendor_num, item_idnt, item_desc, to_date, doc_date, prev_inv_price, inv_price,

			(inv_price/prev_inv_price - 1) as perc_variance,
			
			case
			
			when (inv_price/prev_inv_price - 1) = 0 then 0
				
			else 1 end as classification

		from source_table),
	
	before_offset as (select vendor_num, item_idnt, item_desc, to_date, doc_date, prev_inv_price, inv_price, perc_variance

		from price_change

		where classification = 1),
	
	after_offset as (select *, row_number() over(partition by vendor_num, item_idnt order by doc_date) as rn
			
		from before_offset)
		
select

	a.vendor_num, a.item_idnt, a.item_desc,
	
	a.doc_date as from_date, coalesce(b.to_date, c.max_doc_date) as to_date, a.inv_price, a.prev_inv_price, a.perc_variance

from after_offset a

left join after_offset b

on a.vendor_num = b.vendor_num and a.item_idnt = b.item_idnt and a.rn = b.rn - 1

left join max_doc_date c

on a.vendor_num = c.vendor_num and a.item_idnt = c.item_idnt;
```

**Script**: [Historical Price.sql](https://github.com/ngtridung97/Sql/blob/master/Historical%20Price.sql)

### Random selection A/B testing
----------

Suppose we didn't have invoice detail, only got invoice hard copy in SAP system but we need to randomly pick 5 invoices from 3 vendors, then search in SAP to dertermine category of them.

**RAND() and ROW_NUMBER() functions can help us in this case**

```sql
with

	rn as (select acc_doc_num, fiscal_yr, clientid, vendor_num, row_number() over (partition by vendor_num order by random()) as rn
	
	    from public.ap_tf
	    
	    where doc_type = 'KD') -- KD means invoice
    
select

	vendor_num, acc_doc_num, fiscal_yr, clientid

from rn

where rn <= 5;
```
**Script**: [Random Picker.sql](https://github.com/ngtridung97/Sql/blob/master/Random%20Picker.sql)

### Feedback & Suggestions
----------
Please feel free to fork, comment or give feedback to ng.tridung97@gmail.com
