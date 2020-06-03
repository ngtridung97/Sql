Suppose you were running grocery stores, financial services, or gym memberships, you would care about how many new customers engaged in your business as well as how many customers returned to you again. The metric, which indicates that scenario, is called [retention](https://en.wikipedia.org/wiki/Customer_retention#:~:text=Customer%20retention%20refers%20to%20the,or%20to%20non%2Duse%20entirely.). High customer retention means they tend to return, continue to buy or in some other way not defect to another product or business, or to non-use entirely.

**Features:**
+ Database: [PostgreSQL 12.1 64-bit](https://www.postgresql.org/download/)
+ Dataset: [Sample.csv](https://github.com/ngtridung97/Sql/blob/master/Retention/Sample.csv)
+ Sample Period: January 2016 - December 2016

See how it works below

### Retention over time
----------
Customer retention curve can be used for understanding our clients, and will draw an explanation to other things like sales figures or impact of marketing initiatives. There is an easy way to visualize key interaction between customers and the business, which could be known as, whether or not customers return after their first visit.

**Gather all user_id from the selected month**
```sql
with

	start_month as (select user_id
	
		from public.transaction
		
		group by user_id
		
		having to_char(min(transaction_date), 'yyyy-mm') = '2016-01')
```
**Aggregate user in the CTE above**
```sql		
select 

	to_char(transaction_date, 'yyyy-mm') as transaction_ym,
	
	count(distinct user_id) as count_user
	
from public.transaction

where user_id in (select user_id from start_month)

group by 1;
```
### New vs Existing customer
----------
### Cohort Analysis
----------

### Feedback & Suggestions
----------
Feel free to fork, comment or give feedback to ng.tridung97@gmail.com