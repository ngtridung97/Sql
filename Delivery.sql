/* Assume that we have a sample Delivery table look like this

vendor_num|ref_num |doc_date  |inv_ext_cost|delivery_method|
----------|--------|----------|------------|---------------|
6021709   |SI508608|2019-01-02|   $2,293.00|DTS            |
6021709   |SI508609|2019-01-02|   $5,742.00|DC             |
6021709   |SI508610|2019-01-02|   $9,324.00|DTS            |
6021709   |SI508611|2019-01-02|   $4,008.00|DC             |
6021709   |SI508612|2019-01-02|   $1,902.00|DC             |
6056890   |SI508613|2019-01-02|   $3,929.00|DC             |
6056890   |SI508614|2019-01-02|   $3,267.00|DC             |
6056890   |SI508615|2019-01-02|   $6,628.00|DC             |
6056890   |SI508616|2019-01-02|   $4,086.00|DC             |
6056890   |SI508617|2019-01-02|   $6,751.00|DC             |
6046789   |SI508618|2019-01-02|   $4,916.00|DTS            |
6046789   |SI508619|2019-01-02|   $8,015.00|DTS            |
6046789   |SI508620|2019-01-02|   $3,465.00|DTS            |
6046789   |SI508621|2019-01-02|   $6,700.00|DTS            |
6046789   |SI508622|2019-01-02|   $3,877.00|DTS            |
6021456   |SI508623|2019-01-02|   $3,818.00|DTV            |
6021456   |SI508624|2019-01-02|   $8,210.00|DTS            |
6021456   |SI508625|2019-01-02|   $1,132.00|DTS            |
6021456   |SI508626|2019-01-02|   $3,794.00|DC             |
6021456   |SI508627|2019-01-02|   $7,082.00|DC             |

The Manager wants to know which vendors have used DTS but have not used DTV method, then sends them an email to promote this delivery type. Suppose DTS would cost us more freight charge than DTV. */

-- 1. First approach is using not exists and correlated subquery to display vendors have not used DTV, then filter one more condtition to detect which still use DTS. 

select distinct vendor_num

from public.delivery a

where not exists(select *

	from public.delivery

	where vendor_num = a.vendor_num
	
	and delivery_method = 'DTV')
	
and delivery_method = 'DTS';