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

Sample description: This table could be in many contexts: selling groceries, financial services or gym memberships.

The Manager wants to know about Customer Retenion which is one of the key metrics that influences revenue. */