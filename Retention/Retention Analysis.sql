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