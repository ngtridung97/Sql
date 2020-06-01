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


-- 3. Cohort Analysis

with

	min_date as (select user_id, min(transaction_date) as min_transaction_date

		from public.transaction
		
		group by user_id),

	cohort_month as (select user_id, date_trunc('month', min_transaction_date) as cohort_month
  
		from min_date),
		
	user_log as (select a.user_id, date_part('month', age(date_trunc('month', a.transaction_date), b.cohort_month)) as month_number
  
		from public.transaction a
  
		left join cohort_month b
		
		on a.user_id = b.user_id
  
		group by 1, 2),
		
	month_number_size as (select b.cohort_month, a.month_number, count(*) as count_user
  
		from user_log a
  
		left join cohort_month b
		
		on a.user_id = b.user_id
  
		group by 1, 2),	
		
	cohort_size as (select cohort_month, count(*) as count_user
  
		from cohort_month

		group by 1)
		
select

	m.cohort_month,
	
	c.count_user,
	
	m.month_number,
	
	(m.count_user::float/c.count_user) as retention_rate
	
from month_number_size m

left join cohort_size c

on m.cohort_month = c.cohort_month

order by 1, 3;

/* Result

cohort_month       |count_user|month_number|retention_rate     |
-------------------|----------|------------|-------------------|
2016-01-01 00:00:00|       242|         0.0|                1.0|
2016-01-01 00:00:00|       242|         1.0| 0.2727272727272727|
2016-01-01 00:00:00|       242|         2.0|0.28512396694214875|
2016-01-01 00:00:00|       242|         3.0|0.43388429752066116|
2016-01-01 00:00:00|       242|         4.0|0.35537190082644626|
2016-01-01 00:00:00|       242|         5.0| 0.2975206611570248|
2016-01-01 00:00:00|       242|         6.0| 0.2644628099173554|
2016-01-01 00:00:00|       242|         7.0| 0.2603305785123967|
2016-01-01 00:00:00|       242|         8.0|0.23553719008264462|
2016-01-01 00:00:00|       242|         9.0|0.21487603305785125|
2016-01-01 00:00:00|       242|        10.0| 0.1859504132231405|
2016-01-01 00:00:00|       242|        11.0|0.16942148760330578|
2016-02-01 00:00:00|       119|         0.0|                1.0|
2016-02-01 00:00:00|       119|         1.0|0.46218487394957986|
2016-02-01 00:00:00|       119|         2.0|0.36134453781512604|
2016-02-01 00:00:00|       119|         3.0|0.33613445378151263|
2016-02-01 00:00:00|       119|         4.0| 0.2605042016806723|
2016-02-01 00:00:00|       119|         5.0| 0.2605042016806723|
2016-02-01 00:00:00|       119|         6.0|0.25210084033613445|
2016-02-01 00:00:00|       119|         7.0| 0.2605042016806723|
2016-02-01 00:00:00|       119|         8.0|0.20168067226890757|
2016-02-01 00:00:00|       119|         9.0|0.15966386554621848|
2016-02-01 00:00:00|       119|        10.0|0.13445378151260504|
2016-03-01 00:00:00|       236|         0.0|                1.0|
2016-03-01 00:00:00|       236|         1.0| 0.4406779661016949|
2016-03-01 00:00:00|       236|         2.0| 0.3474576271186441|
2016-03-01 00:00:00|       236|         3.0|  0.288135593220339|
2016-03-01 00:00:00|       236|         4.0| 0.2711864406779661|
2016-03-01 00:00:00|       236|         5.0| 0.2584745762711864|
2016-03-01 00:00:00|       236|         6.0|0.23728813559322035|
2016-03-01 00:00:00|       236|         7.0| 0.2330508474576271|
2016-03-01 00:00:00|       236|         8.0| 0.2245762711864407|
2016-03-01 00:00:00|       236|         9.0| 0.2076271186440678|
2016-04-01 00:00:00|       131|         0.0|                1.0|
2016-04-01 00:00:00|       131|         1.0| 0.5190839694656488|
2016-04-01 00:00:00|       131|         2.0| 0.2824427480916031|
2016-04-01 00:00:00|       131|         3.0| 0.2595419847328244|
2016-04-01 00:00:00|       131|         4.0| 0.2366412213740458|
2016-04-01 00:00:00|       131|         5.0| 0.2748091603053435|
2016-04-01 00:00:00|       131|         6.0|0.26717557251908397|
2016-04-01 00:00:00|       131|         7.0|0.24427480916030533|
2016-04-01 00:00:00|       131|         8.0|0.19083969465648856|
2016-05-01 00:00:00|       356|         0.0|                1.0|
2016-05-01 00:00:00|       356|         1.0|0.32865168539325845|
2016-05-01 00:00:00|       356|         2.0| 0.2893258426966292|
2016-05-01 00:00:00|       356|         3.0| 0.3539325842696629|
2016-05-01 00:00:00|       356|         4.0| 0.3707865168539326|
2016-05-01 00:00:00|       356|         5.0|0.30337078651685395|
2016-05-01 00:00:00|       356|         6.0| 0.3061797752808989|
2016-05-01 00:00:00|       356|         7.0| 0.2808988764044944|
2016-06-01 00:00:00|       258|         0.0|                1.0|
2016-06-01 00:00:00|       258|         1.0|0.31007751937984496|
2016-06-01 00:00:00|       258|         2.0| 0.3682170542635659|
2016-06-01 00:00:00|       258|         3.0|0.38372093023255816|
2016-06-01 00:00:00|       258|         4.0| 0.2868217054263566|
2016-06-01 00:00:00|       258|         5.0|0.35271317829457366|
2016-06-01 00:00:00|       258|         6.0| 0.2868217054263566|
2016-07-01 00:00:00|       214|         0.0|                1.0|
2016-07-01 00:00:00|       214|         1.0|0.40186915887850466|
2016-07-01 00:00:00|       214|         2.0|0.46261682242990654|
2016-07-01 00:00:00|       214|         3.0|0.35514018691588783|
2016-07-01 00:00:00|       214|         4.0| 0.3317757009345794|
2016-07-01 00:00:00|       214|         5.0| 0.2616822429906542|
2016-08-01 00:00:00|       161|         0.0|                1.0|
2016-08-01 00:00:00|       161|         1.0| 0.4906832298136646|
2016-08-01 00:00:00|       161|         2.0|  0.391304347826087|
2016-08-01 00:00:00|       161|         3.0| 0.3416149068322981|
2016-08-01 00:00:00|       161|         4.0| 0.2670807453416149|
2016-09-01 00:00:00|       192|         0.0|                1.0|
2016-09-01 00:00:00|       192|         1.0| 0.3697916666666667|
2016-09-01 00:00:00|       192|         2.0| 0.4739583333333333|
2016-09-01 00:00:00|       192|         3.0|            0.34375|
2016-10-01 00:00:00|        87|         0.0|                1.0|
2016-10-01 00:00:00|        87|         1.0| 0.4367816091954023|
2016-10-01 00:00:00|        87|         2.0| 0.3218390804597701|
2016-11-01 00:00:00|       107|         0.0|                1.0|
2016-11-01 00:00:00|       107|         1.0|0.45794392523364486|
2016-12-01 00:00:00|        64|         0.0|                1.0| */