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

Sample description:
    1. DTS is Direct to Store: vendors deliver goods to our Store.
    2. DC is Delivery Center: vendors deliver goods to our DC.
    3. DTV is Direct to Vendor: we collect goods from vendors.

The Manager wants to know which vendors have used DTS but have not used DTV method, then sends them an email to promote this delivery type. Suppose DTS would cost us more freight charge than DTV. */

-- 1. First approach is using not exists and correlated subquery to display vendors have not used DTV, then filter one more condtition to detect which still use DTS. 

select distinct vendor_num

from public.delivery a

where not exists(select *

	from public.delivery

	where vendor_num = a.vendor_num
	
	and delivery_method = 'DTV') -- Have not done Action B
	
and delivery_method = 'DTS'; -- Have done Action A

-- 2. Second approach is marking DTV as 0 and the rest as 1. If vendors used DTV before, they will be assigned both 1 and 0 value, so vendors who have not used DTV have min value = 1

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

/* Result

vendor_num|
----------|
6021709   |
6046789   | */