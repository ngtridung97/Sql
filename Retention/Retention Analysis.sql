/* Assume that we have a sample transaction table look like this.

 id |user_id|transaction_date|
----|-------|----------------|
   1|    522|      2016-01-01|
   2|   2139|      2016-01-01|
   3|   2232|      2016-01-01|
   4|   2017|      2016-01-01|
   5|   2168|      2016-01-01|
   6|   2139|      2016-01-02|
   7|    707|      2016-01-02|
   8|   1018|      2016-01-02|
   9|   1345|      2016-01-02|
  10|   1429|      2016-01-02|
 ---                     ---
7881|   1630|      2016-12-31|

Sample description:

    1. This table could be in many contexts: selling groceries, financial services or gym memberships.
    2. transaction_date from Jan 2016 to Dec 2016.

The Manager wants to know more about Customer Retenion which is one of the key metrics that influences revenue. */


-- 1. Customer Retention over time

with

	start_month as (select user_id
	
		from public.transaction
		
		group by user_id
		
		having to_char(min(transaction_date), 'yyyy-mm') = '2016-01') -- we can adjust difference month to indicate difference result
		
select 

	to_char(transaction_date, 'yyyy-mm') as transaction_ym,
	
	count(distinct user_id) as count_user
	
from public.transaction

where user_id in (select user_id from start_month)

group by 1;

/* Result

transaction_ym|count_user|
--------------|----------|
2016-01       |       242|
2016-02       |        66|
2016-03       |        69|
2016-04       |       105|
2016-05       |        86|
2016-06       |        72|
2016-07       |        64|
2016-08       |        63|
2016-09       |        57|
2016-10       |        52|
2016-11       |        45|
2016-12       |        41| */


-- 2. New vs Existing customers retention clustering

with

	transaction_log as (select user_id,

            date_trunc('month', transaction_date) as trunc_month,
    
            date_part('month', age(transaction_date, '2016-01-01')) as month_number -- instead of 01-01-2016, we can generate min(trans_date) in another CTE above

		from public.transaction
		
		group by 1, 2, 3),

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

select

	trunc_month,
	
	cust_type,
	
	count(user_id) as count_user

from category

group by 1, 2

order by 1, 2;

/* Result

trunc_month        |cust_type|count_user|
-------------------|---------|----------|
2016-01-01 00:00:00|New      |       242|
2016-02-01 00:00:00|New      |       119|
2016-02-01 00:00:00|Retained |        66|
2016-03-01 00:00:00|New      |       236|
2016-03-01 00:00:00|Retained |        70|
2016-03-01 00:00:00|Returning|        54|
2016-04-01 00:00:00|New      |       131|
2016-04-01 00:00:00|Retained |       147|
2016-04-01 00:00:00|Returning|       105|
2016-05-01 00:00:00|New      |       356|
2016-05-01 00:00:00|Retained |       156|
2016-05-01 00:00:00|Returning|       120|
2016-06-01 00:00:00|New      |       258|
2016-06-01 00:00:00|Retained |       200|
2016-06-01 00:00:00|Returning|       125|
2016-07-01 00:00:00|New      |       214|
2016-07-01 00:00:00|Retained |       175|
2016-07-01 00:00:00|Returning|       201|
2016-08-01 00:00:00|New      |       161|
2016-08-01 00:00:00|Retained |       203|
2016-08-01 00:00:00|Returning|       289|
2016-09-01 00:00:00|New      |       192|
2016-09-01 00:00:00|Retained |       268|
2016-09-01 00:00:00|Returning|       321|
2016-10-01 00:00:00|New      |        87|
2016-10-01 00:00:00|Retained |       263|
2016-10-01 00:00:00|Returning|       295|
2016-11-01 00:00:00|New      |       107|
2016-11-01 00:00:00|Retained |       231|
2016-11-01 00:00:00|Returning|       373|
2016-12-01 00:00:00|New      |        64|
2016-12-01 00:00:00|Retained |       228|
2016-12-01 00:00:00|Returning|       319| */