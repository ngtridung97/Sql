/* Assume that we have a sample Invoice Detail table look like this

vendor_num|ref_num |doc_date  |item_idnt|item_desc                                 |inv_price|inv_qty|inv_ext_cost|
----------|--------|----------|---------|------------------------------------------|---------|-------|------------|
6021709   |SI508608|2019-01-02|  1034234|JUMBO FREE RANGE EGGS 12 PACK:800 GRAM    |   $55.00|    240|  $13,200.00|
6021709   |SI508781|2019-01-03|  1034234|JUMBO FREE RANGE EGGS 12 PACK:800 GRAM    |   $55.00|     80|   $4,400.00|
6021709   |SI509109|2019-01-05|  1034234|JUMBO FREE RANGE EGGS 12 PACK:800 GRAM    |   $55.00|    120|   $6,600.00|
6021709   |SI508931|2019-01-04|  1034234|JUMBO FREE RANGE EGGS 12 PACK:800 GRAM    |   $55.00|    120|   $6,600.00|
6021709   |SI508831|2019-01-04|  1034234|JUMBO FREE RANGE EGGS 12 PACK:800 GRAM    |   $55.00|    120|   $6,600.00|
6021709   |SI509519|2019-01-09|  1034234|JUMBO FREE RANGE EGGS 12 PACK:800 GRAM    |   $48.25|    239|  $11,531.75|
6021709   |SI509057|2019-01-07|  1034234|JUMBO FREE RANGE EGGS 12 PACK:800 GRAM    |   $55.00|    120|   $6,600.00|
6021709   |SI509302|2019-01-08|  1034234|JUMBO FREE RANGE EGGS 12 PACK:800 GRAM    |   $48.25|    120|   $5,790.00|
6021709   |SI509515|2019-01-09|  1034234|JUMBO FREE RANGE EGGS 12 PACK:800 GRAM    |   $48.25|    120|   $5,790.00|
6021709   |SI509739|2019-01-10|  1034234|JUMBO FREE RANGE EGGS 12 PACK:800 GRAM    |   $48.25|    120|   $5,790.00|
6021709   |SI509978|2019-01-11|  1034234|JUMBO FREE RANGE EGGS 12 PACK:800 GRAM    |   $48.25|    120|   $5,790.00|
6021709   |SI510124|2019-01-12|  1034234|JUMBO FREE RANGE EGGS 12 PACK:800 GRAM    |   $48.25|    200|   $9,650.00|
6021709   |SI509477|2019-01-09|  1034234|JUMBO FREE RANGE EGGS 12 PACK:800 GRAM    |   $48.25|    120|   $5,790.00|
6021709   |SI509697|2019-01-10|  1034234|JUMBO FREE RANGE EGGS 12 PACK:800 GRAM    |   $48.25|    120|   $5,790.00|
6021709   |SI509942|2019-01-11|  1034234|JUMBO FREE RANGE EGGS 12 PACK:800 GRAM    |   $48.25|     80|   $3,860.00|
6021709   |SI510604|2019-01-16|  1034234|JUMBO FREE RANGE EGGS 12 PACK:800 GRAM    |   $50.75|     80|   $4,060.00|
6021709   |SI510875|2019-01-17|  1034234|JUMBO FREE RANGE EGGS 12 PACK:800 GRAM    |   $50.75|    120|   $6,090.00|
6021709   |SI510580|2019-01-16|  1034234|JUMBO FREE RANGE EGGS 12 PACK:800 GRAM    |   $50.75|    160|   $8,120.00|
6021709   |SI510829|2019-01-17|  1034234|JUMBO FREE RANGE EGGS 12 PACK:800 GRAM    |   $50.75|    120|   $6,090.00|
6021709   |SI510416|2019-01-15|  1034234|JUMBO FREE RANGE EGGS 12 PACK:800 GRAM    |   $50.75|    120|   $6,090.00|
6021709   |SI510639|2019-01-16|  1034234|JUMBO FREE RANGE EGGS 12 PACK:800 GRAM    |   $50.75|    120|   $6,090.00|
6021709   |SI509790|2019-01-10|  1034234|JUMBO FREE RANGE EGGS 12 PACK:800 GRAM    |   $48.25|     80|   $3,860.00|
6021709   |SI510827|2019-01-16|  1034234|JUMBO FREE RANGE EGGS 12 PACK:800 GRAM    |   $50.75|    200|  $10,150.00|
6021709   |SI511296|2019-01-21|  1034234|JUMBO FREE RANGE EGGS 12 PACK:800 GRAM    |   $50.75|    120|   $6,090.00|
6021709   |SI511575|2019-01-22|  1034234|JUMBO FREE RANGE EGGS 12 PACK:800 GRAM    |   $50.75|    160|   $8,120.00|
6021709   |SI508931|2019-01-04|  2680008|FREE RANGE EGGS 6 PACK 300G:300 GRAM      |   $47.45|    120|   $5,694.00|
6021709   |SI509978|2019-01-11|  2680008|FREE RANGE EGGS 6 PACK 300G:300 GRAM      |   $47.45|    280|  $13,286.00|
6021709   |SI509477|2019-01-09|  2680008|FREE RANGE EGGS 6 PACK 300G:300 GRAM      |   $47.45|    120|   $5,694.00|
6021709   |SI509697|2019-01-10|  2680008|FREE RANGE EGGS 6 PACK 300G:300 GRAM      |   $47.45|    120|   $5,694.00|
6021709   |SI510604|2019-01-16|  2680008|FREE RANGE EGGS 6 PACK 300G:300 GRAM      |   $50.50|     80|   $4,040.00|
6021709   |SI510875|2019-01-17|  2680008|FREE RANGE EGGS 6 PACK 300G:300 GRAM      |   $50.50|    120|   $6,060.00|
6021709   |SI510580|2019-01-16|  2680008|FREE RANGE EGGS 6 PACK 300G:300 GRAM      |   $50.50|     40|   $2,020.00|
6021709   |SI510829|2019-01-17|  2680008|FREE RANGE EGGS 6 PACK 300G:300 GRAM      |   $50.50|     80|   $4,040.00|
6021709   |SI510703|2019-01-17|  2680008|FREE RANGE EGGS 6 PACK 300G:300 GRAM      |   $50.50|     80|   $4,040.00|
6021709   |SI510851|2019-01-17|  2680008|FREE RANGE EGGS 6 PACK 300G:300 GRAM      |   $50.50|    320|  $16,160.00|
6021709   |SI509507|2019-01-09|  2680008|FREE RANGE EGGS 6 PACK 300G:300 GRAM      |   $47.45|    120|   $5,694.00|
6021709   |SI510827|2019-01-16|  2680008|FREE RANGE EGGS 6 PACK 300G:300 GRAM      |   $50.50|    200|  $10,100.00|
6021709   |SI510923|2019-01-17|  2680008|FREE RANGE EGGS 6 PACK 300G:300 GRAM      |   $50.50|    120|   $6,060.00|
6021709   |SI511974|2019-01-24|  2680008|FREE RANGE EGGS 6 PACK 300G:300 GRAM      |   $50.50|    560|  $28,280.00|
6021709   |SI511758|2019-01-24|  2680008|FREE RANGE EGGS 6 PACK 300G:300 GRAM      |   $50.50|     80|   $4,040.00|
6021709   |SI511969|2019-01-24|  2680008|FREE RANGE EGGS 6 PACK 300G:300 GRAM      |   $50.50|    240|  $12,120.00|
6021709   |SI512450|2019-01-29|  2680008|FREE RANGE EGGS 6 PACK 300G:300 GRAM      |   $50.50|     80|   $4,040.00|
6021709   |SI512947|2019-01-31|  2680008|FREE RANGE EGGS 6 PACK 300G:300 GRAM      |   $50.50|    120|   $6,060.00|
6021709   |SI514223|2019-02-07|  2680008|FREE RANGE EGGS 6 PACK 300G:300 GRAM      |   $59.25|    200|  $11,850.00|
6021709   |SI513887|2019-02-07|  2680008|FREE RANGE EGGS 6 PACK 300G:300 GRAM      |   $59.25|    200|  $11,850.00|
6021709   |SI513402|2019-02-04|  2680008|FREE RANGE EGGS 6 PACK 300G:300 GRAM      |   $59.25|     80|   $4,740.00|
6021709   |SI514336|2019-02-08|  2680008|FREE RANGE EGGS 6 PACK 300G:300 GRAM      |   $50.50|    280|  $14,140.00|
6021709   |SI515040|2019-02-12|  2680008|FREE RANGE EGGS 6 PACK 300G:300 GRAM      |   $50.50|    160|   $8,080.00|
6021709   |SI515242|2019-02-13|  2680008|FREE RANGE EGGS 6 PACK 300G:300 GRAM      |   $50.50|    160|   $8,080.00|
6021709   |SI515042|2019-02-14|  2680008|FREE RANGE EGGS 6 PACK 300G:300 GRAM      |   $50.50|     80|   $4,040.00|
6021709   |SI508354|2019-01-02|  3169697|ORGANIC FREE RANGE EGGS 12PK 600G:600 GRAM|   $87.00|     40|   $3,480.00|
6021709   |SI508347|2019-01-02|  3169697|ORGANIC FREE RANGE EGGS 12PK 600G:600 GRAM|   $87.00|     80|   $6,960.00|
6021709   |SI508558|2019-01-03|  3169697|ORGANIC FREE RANGE EGGS 12PK 600G:600 GRAM|   $87.00|     40|   $3,480.00|
6021709   |SI508584|2019-01-03|  3169697|ORGANIC FREE RANGE EGGS 12PK 600G:600 GRAM|   $87.00|    200|  $17,400.00|
6021709   |SI508828|2019-01-04|  3169697|ORGANIC FREE RANGE EGGS 12PK 600G:600 GRAM|   $87.00|    160|  $13,920.00|
6021709   |SI508875|2019-01-04|  3169697|ORGANIC FREE RANGE EGGS 12PK 600G:600 GRAM|   $87.00|    160|  $13,920.00|
6021709   |SI509015|2019-01-07|  3169697|ORGANIC FREE RANGE EGGS 12PK 600G:600 GRAM|   $87.00|     40|   $3,480.00|
6021709   |SI508823|2019-01-04|  3169697|ORGANIC FREE RANGE EGGS 12PK 600G:600 GRAM|   $87.00|    160|  $13,920.00|
6021709   |SI509039|2019-01-07|  3169697|ORGANIC FREE RANGE EGGS 12PK 600G:600 GRAM|   $87.00|     40|   $3,480.00|
6021709   |SI509327|2019-01-08|  3169697|ORGANIC FREE RANGE EGGS 12PK 600G:600 GRAM|   $87.00|     40|   $3,480.00|
6021709   |SI509055|2019-01-07|  3169697|ORGANIC FREE RANGE EGGS 12PK 600G:600 GRAM|   $87.00|     80|   $6,960.00|
6021709   |SI509293|2019-01-08|  3169697|ORGANIC FREE RANGE EGGS 12PK 600G:600 GRAM|   $87.00|     80|   $6,960.00|
6021709   |SI509522|2019-01-09|  3169697|ORGANIC FREE RANGE EGGS 12PK 600G:600 GRAM|   $87.00|     80|   $6,960.00|
6021709   |SI509735|2019-01-10|  3169697|ORGANIC FREE RANGE EGGS 12PK 600G:600 GRAM|   $85.50|     80|   $6,840.00|
6021709   |SI509791|2019-01-10|  3169697|ORGANIC FREE RANGE EGGS 12PK 600G:600 GRAM|   $85.50|    120|  $10,260.00|
6021709   |SI509938|2019-01-11|  3169697|ORGANIC FREE RANGE EGGS 12PK 600G:600 GRAM|   $85.50|    120|  $10,260.00|
6021709   |SI509948|2019-01-11|  3169697|ORGANIC FREE RANGE EGGS 12PK 600G:600 GRAM|   $85.50|    160|  $13,680.00|
6021709   |SI510168|2019-01-14|  3169697|ORGANIC FREE RANGE EGGS 12PK 600G:600 GRAM|   $85.50|     80|   $6,840.00|
6021709   |SI509959|2019-01-11|  3169697|ORGANIC FREE RANGE EGGS 12PK 600G:600 GRAM|   $85.50|    120|  $10,260.00|
6021709   |SI510147|2019-01-14|  3169697|ORGANIC FREE RANGE EGGS 12PK 600G:600 GRAM|   $85.50|     80|   $6,840.00|
6021709   |SI510167|2019-01-14|  3169697|ORGANIC FREE RANGE EGGS 12PK 600G:600 GRAM|   $85.50|    120|  $10,260.00|
6021709   |SI510411|2019-01-15|  3169697|ORGANIC FREE RANGE EGGS 12PK 600G:600 GRAM|   $85.50|     40|   $3,420.00|
6021709   |SI510407|2019-01-15|  3169697|ORGANIC FREE RANGE EGGS 12PK 600G:600 GRAM|   $85.50|     40|   $3,420.00|
6021709   |SI510602|2019-01-16|  3169697|ORGANIC FREE RANGE EGGS 12PK 600G:600 GRAM|   $85.50|     40|   $3,420.00|
6021709   |SI510583|2019-01-16|  3169697|ORGANIC FREE RANGE EGGS 12PK 600G:600 GRAM|   $85.50|     40|   $3,420.00|

Sample description:
    1. Historical pricing for 3 items in Jan & Feb 2019.
    2. Link with AP data by ref_num column.

The Manager wants to know the date range of price change for each item. */

-- 1. First idea is agg function min and max, then group by vendor_num, item_idnt, inv_price

select

	vendor_num, item_idnt, item_desc, min(doc_date) as min_doc_date, max(doc_date) as max_doc_date, inv_price
	
from public.invoice_detail

group by vendor_num, item_idnt, item_desc, inv_price;

/* Result

vendor_num|item_idnt|item_desc                                 |min_doc_date|max_doc_date|inv_price|
----------|---------|------------------------------------------|------------|------------|---------|
6021709   |  1034234|JUMBO FREE RANGE EGGS 12 PACK:800 GRAM    |  2019-01-08|  2019-01-12|   $48.25|
6021709   |  1034234|JUMBO FREE RANGE EGGS 12 PACK:800 GRAM    |  2019-01-15|  2019-01-22|   $50.75|
6021709   |  1034234|JUMBO FREE RANGE EGGS 12 PACK:800 GRAM    |  2019-01-02|  2019-01-07|   $55.00|
6021709   |  2680008|FREE RANGE EGGS 6 PACK 300G:300 GRAM      |  2019-01-04|  2019-01-11|   $47.45|
6021709   |  2680008|FREE RANGE EGGS 6 PACK 300G:300 GRAM      |  2019-01-16|  2019-02-14|   $50.50|
6021709   |  2680008|FREE RANGE EGGS 6 PACK 300G:300 GRAM      |  2019-02-04|  2019-02-07|   $59.25|
6021709   |  3169697|ORGANIC FREE RANGE EGGS 12PK 600G:600 GRAM|  2019-01-10|  2019-01-16|   $85.50|
6021709   |  3169697|ORGANIC FREE RANGE EGGS 12PK 600G:600 GRAM|  2019-01-02|  2019-01-09|   $87.00|