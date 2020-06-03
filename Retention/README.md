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
Another idea we could have is: the people who came in January, how many of them returned in February, or did they come across in March afterward?

In this case, we need to know some insights such as what ratio of our customers who are retained in any given month, how many are returning, or how many are new.

To solve the problem, we would like to improve our view a bit to identify the time lapse between each visit. Hence, for each person and each month, we could detect when the next visit is.

**Create a table where each customer’s transaction is logged by month**
```sql
with

	transaction_log as (select user_id, date_trunc('month', transaction_date) as trunc_month, date_part('month', age(transaction_date, '2016-01-01')) as month_number

		from public.transaction
		
		group by 1, 2, 3),
```
**Calculate time gaps between transactions and categorize that**
```sql
	time_lapse as (select user_id, trunc_month, month_number, lag(month_number) over (partition by user_id order by user_id, month_number)
	
		from transaction_log),
		
	time_diff as (select user_id, trunc_month, (month_number - lag) as time_diff
	
		from time_lapse),
		
	category as (select user_id, trunc_month,
	
			case
				when time_diff = 1 then 'Retained'
				when time_diff > 1 then 'Returning'
				when time_diff is null then 'New'
			end as cust_type
			
		from time_diff)
```
**And establish the number of customers who visited monthly by categories**
```sql
select

	trunc_month,
	
	cust_type,
	
	count(user_id) as count_user

from category

group by 1, 2

order by 1, 2;
```
### Cohort Analysis
----------
A popular way to visualize customer retention is using [Cohort Analysis](https://amplitude.com/blog/2015/11/24/cohorts-to-improve-your-retention), i.e. defining each user by their first visit and then tracking how they return over time.

Our final result will display the number of new users is increasing (might be decreasing too :() in every cohort year, month, or week, as well as the following retention rate from that moment.

### Feedback & Suggestions
----------
Feel free to fork, comment or give feedback to ng.tridung97@gmail.com