/* Assume that we have a sample Account Payable (AP) table look like this

vendor_num|doc_dte   |process_dte|ref_num     |absvalue|totalinvamt|taxablevalue|gstvalue|doc_type|clientid|acc_doc_num|fiscal_yr|currency|clring_dte|clring_doc_num|net_pay_amt|disc_amt|disc_perc|
----------|----------|-----------|------------|--------|-----------|------------|--------|--------|--------|-----------|---------|--------|----------|--------------|-----------|--------|---------|
6021709   |2020-06-10| 2018-01-11|INVC9       | $142.62|    $142.62|     $129.65|  $12.97|KD      |1061    |3400711244 |     2019|AUD     |2019-03-11|3100038497    |  $3,027.26|   $0.00|     0.00|
6021709   |2018-03-11| 2018-03-11|INVC99      | $218.42|    $218.42|     $198.56|  $19.86|KD      |1061    |3400719055 |     2019|AUD     |2019-07-11|3100039545    |  $7,192.38|   $0.00|     0.00|
6021709   |2018-02-11| 2018-03-11|INVC98      | $167.05|    $167.05|     $151.84|  $15.21|KD      |1061    |3400719373 |     2019|AUD     |2019-07-11|3100039545    |  $7,192.38|   $0.00|     0.00|
6021709   |2018-03-11| 2018-03-11|INVC96      |  $91.64|     $91.64|      $83.30|   $8.34|KD      |1061    |3400719547 |     2019|AUD     |2019-07-11|3100039545    |  $7,192.38|   $0.00|     0.00|
6021709   |2018-03-11| 2018-03-11|INVC94      |  $92.69|     $92.69|      $84.26|   $8.43|KD      |1061    |3400719218 |     2019|AUD     |2019-07-11|3100039545    |  $7,192.38|   $0.00|     0.00|
6021709   |2018-03-11| 2018-03-11|INVC91      | $188.85|    $188.85|     $171.68|  $17.17|KD      |1061    |3400718996 |     2019|AUD     |2019-07-11|3100039545    |  $7,192.38|   $0.00|     0.00|
6021709   |2018-03-11| 2018-03-11|INVC88      | $242.36|    $242.36|     $220.32|  $22.04|KD      |1061    |3400718483 |     2019|AUD     |2019-07-11|3100039545    |  $7,192.38|   $0.00|     0.00|
6021709   |2018-03-11| 2018-03-11|INVC87      | $182.46|    $182.46|     $165.88|  $16.58|KD      |1061    |3400719390 |     2019|AUD     |2019-07-11|3100039545    |  $7,192.38|   $0.00|     0.00|
6021709   |2018-03-11| 2018-04-11|INVC92      | $299.33|    $299.33|     $272.12|  $27.21|KD      |1061    |3400721212 |     2019|AUD     |2019-07-11|3100039545    |  $7,192.38|   $0.00|     0.00|
6021709   |2018-03-11| 2018-04-11|INVC86      | $213.46|    $213.46|     $194.06|  $19.40|KD      |1061    |3400722628 |     2019|AUD     |2019-07-11|3100039545    |  $7,192.38|   $0.00|     0.00|
6021709   |2018-03-11| 2018-05-11|INVC90      | $188.55|    $188.55|     $171.38|  $17.17|KD      |1061    |3400728717 |     2019|AUD     |2019-07-11|3100039545    |  $7,192.38|   $0.00|     0.00|
---																																																---
6021709   |2018-03-11| 2018-07-11|INVC93      |  $75.12|     $75.12|      $68.28|   $6.84|KD      |1061    |3400739398 |     2019|AUD     |2019-07-11|3100039545    |  $7,192.38|   $0.00|     0.00|
6021709   |2018-03-11| 2019-01-11|INVC95      | $109.51|    $109.51|      $99.56|   $9.95|KD      |1061    |3400771467 |     2019|AUD     |2020-03-11|3100041827    |  $4,227.30|   $0.00|     0.00|
6021709   |2018-07-11| 2019-03-11|RD10481603-1|  $44.11|     $44.11|      $40.10|   $4.01|KV      |1061    |4000005341 |     2019|AUD     |2019-04-11|3100039324    |  $1,708.45|   $0.00|     0.00|
6021709   |2019-01-11| 2019-04-11|RD10483039-1|  $63.08|     $63.08|      $57.34|   $5.74|KV      |1061    |4000005345 |     2019|AUD     |2019-07-11|3100039545    |  $7,192.38|   $0.00|     0.00|
6021709   |2019-03-11| 2019-08-11|RD10483536-1|  $12.12|     $12.12|      $11.02|   $1.10|KV      |1061    |4000005468 |     2019|AUD     |2019-09-11|3100040215    |  $4,044.57|   $0.00|     0.00|
6021709   |2020-05-11| 2020-05-11|INVC796     |  $61.44|     $61.44|      $55.86|   $5.58|KD      |1061    |3400866499 |     2019|AUD     |2019-01-12|3100046272    |  $9,326.16|   $0.00|     0.00|
6021709   |2020-05-11| 2020-05-11|INVC795     | $384.73|    $384.73|     $349.77|  $34.96|KD      |1061    |3400865558 |     2019|AUD     |2019-01-12|3100046272    |  $9,326.16|   $0.00|     0.00|
6021709   |2018-01-12| 2018-01-12|INVC850     |  $68.66|     $68.66|      $62.40|   $6.26|KD      |1061    |3400873954 |     2019|AUD     |2019-05-12|3100047380    |  $7,779.68|   $0.00|     0.00|
6021709   |2018-03-12| 2018-03-12|INVC877     | $111.03|    $111.03|     $100.94|  $10.09|KD      |1061    |3400884556 |     2019|AUD     |2019-05-12|3100047380    |  $7,779.68|   $0.00|     0.00|
6021709   |2018-03-12| 2018-03-12|INVC876     | $412.34|    $412.34|     $374.87|  $37.47|KD      |1061    |3400883758 |     2019|AUD     |2019-05-12|3100047380    |  $7,779.68|   $0.00|     0.00|
6021709   |2018-03-12| 2018-03-12|INVC875     | $297.29|    $297.29|     $270.26|  $27.03|KD      |1061    |3400884832 |     2019|AUD     |2019-05-12|3100047380    |  $7,779.68|   $0.00|     0.00|
6021709   |2018-03-12| 2018-03-12|INVC873     |  $41.89|     $41.89|      $38.08|   $3.81|KD      |1061    |3400884441 |     2019|AUD     |2019-05-12|3100047380    |  $7,779.68|   $0.00|     0.00|
6021709   |2018-03-12| 2018-03-12|INVC871     | $171.20|    $171.20|     $155.64|  $15.56|KD      |1061    |3400884405 |     2019|AUD     |2019-05-12|3100047380    |  $7,779.68|   $0.00|     0.00|
6021709   |2018-03-12| 2018-03-12|INVC870     | $130.75|    $130.75|     $118.86|  $11.89|KD      |1061    |3400884789 |     2019|AUD     |2019-05-12|3100047380    |  $7,779.68|   $0.00|     0.00|
6021709   |2018-03-12| 2018-03-12|INVC869     | $119.06|    $119.06|     $108.24|  $10.82|KD      |1061    |3400882928 |     2019|AUD     |2019-05-12|3100047380    |  $7,779.68|   $0.00|     0.00|
6021709   |2018-03-12| 2018-03-12|INVC868     | $137.44|    $137.44|     $124.94|  $12.50|KD      |1061    |3400883707 |     2019|AUD     |2019-05-12|3100047380    |  $7,779.68|   $0.00|     0.00|
6021709   |2018-03-12| 2018-03-12|INVC867     |  $50.20|     $50.20|      $45.64|   $4.56|KD      |1061    |3400883636 |     2019|AUD     |2019-05-12|3100047380    |  $7,779.68|   $0.00|     0.00|

Sample description
	1. This table is created by joinning between bseg and bkbf tables from SAP.
	2. Positive number referred to the amount client paid to vendors, negative number referred to the amount client claimed from vendors.
	3. Columns acc_doc_num, fiscal_yr, clientid together are correspond with benlr, gjark, bukrs in SAP system.
	4. Certain amount of transactions will be totallzied and settled by specific clring_doc_num (Remittance Advice).

Below queries are an overview before taking on deeper analysis on this AP data. */

-- 1. Dupp transactions

select

	acc_doc_num, fiscal_yr, clientid, count(*)
	
from public.ap_tf

group by acc_doc_num, fiscal_yr, clientid

having count(*) > 1;

/* Result

acc_doc_num|fiscal_yr|clientid|count|
-----------|---------|--------|-----| */


-- 2. Clearing information - Monitor uncleared transactions distribution

-- https://stackoverflow.com/questions/10404348/sql-server-dynamic-pivot-query

select

	to_char(process_dte, 'YYYY-MM') as process_dte_ym,
	
	sum(case when clring_dte is null then 1 end) as count_unleared_trans,
	
	sum(case when clring_dte is not null then 1 end) as count_cleared_trans
	
from public.ap_tf

group by to_char(process_dte, 'YYYY-MM')

order by to_char(process_dte, 'YYYY-MM');

/* Result

process_dte_ym|count_unleared_trans|count_cleared_trans|
--------------|--------------------|-------------------|
2018-01       |                 606|             416476|
2018-02       |                 486|             375127|
2018-03       |                 112|             369732|
2018-04       |                 380|             408768|
2018-05       |                 438|             413379|
2018-06       |                 217|             386763|
2018-07       |                  73|             396247|
2018-08       |                  58|             415154|
2018-09       |                  73|             384320|
2018-10       |                 197|             419057|
2018-11       |                 573|             406166|
2018-12       |                 546|             393318|
2019-01       |                 543|             410012|
2019-02       |                 469|             379462|
2019-03       |                 592|             400110|
2019-04       |                 671|             370953|
2019-05       |                 510|             411525|
2019-06       |                 510|             398741| */


-- 3. Eft - Monitor mismatch between paid amount and total invoice amount

with

	totalinvamt as (select clring_doc_num, clring_dte, net_pay_amt, sum(totalinvamt) as sum_total
	
		from public.ap_tf
		
		group by clring_doc_num, clring_dte, net_pay_amt),
		
	classification as (select clring_doc_num, clring_dte, net_pay_amt, sum_total,
	
			case when net_pay_amt = sum_total then 'Y' else 'N' end as classification
			
		from totalinvamt)
		
select

	to_char(clring_dte, 'YYYY-MM') as clring_dte_ym,
	
	sum(case when classification = 'Y' then 1 else 0 end) as count_Y,
	
	sum(case when classification = 'N' then 1 else 0 end) as count_N

from classification

group by to_char(clring_dte, 'YYYY-MM')

order by to_char(clring_dte, 'YYYY-MM');

/* Result

clring_dte|count_y|count_n|
----------|-------|-------|
2018-01   |  10975|   2520|
2018-02   |  16624|    398|
2018-03   |  19140|    133|
2018-04   |  16904|     38|
2018-05   |  18307|     52|
2018-06   |  19089|    117|
2018-07   |  17511|    132|
2018-08   |  19548|    439|
2018-09   |  16126|    197|
2018-10   |  18205|     93|
2018-11   |  19073|    247|
2018-12   |  16884|    102|
2019-01   |  16361|     43|
2019-02   |  16051|     33|
2019-03   |  18646|     58|
2019-04   |  16889|     35|
2019-05   |  19107|    106|
2019-06   |  17194|     94|
2019-07   |   4436|   2631|
2019-08   |     51|    361|
2019-09   |     13|    240|
2019-10   |      1|     37| */


-- 4. Volume - Monior distribution of amount by months

select

	to_char(process_dte, 'YYYY-MM') as process_dte_ym,
	
	sum(totalinvamt) as sum_total,
	
	count(totalinvamt) as count_total
	
from public.ap_tf

group by to_char(process_dte, 'YYYY-MM')

order by to_char(process_dte, 'YYYY-MM');

/* Result

process_dte_ym|sum_total    |count_total|
--------------|-------------|-----------|
2018-01       |2388607276.07|     417082|
2018-02       |2333233835.68|     375613|
2018-03       |2433940576.27|     369844|
2018-04       |2031904319.99|     409148|
2018-05       |2511541296.30|     413817|
2018-06       |2315633466.83|     386980|
2018-07       |2293744004.16|     396320|
2018-08       |2636137734.17|     415212|
2018-09       |2245356339.79|     384393|
2018-10       |2624438225.51|     419254|
2018-11       |2707744708.08|     406739|
2018-12       |2462672194.37|     393864|
2019-01       |2430391402.78|     410555|
2019-02       |2306516749.98|     379931|
2019-03       |2409570201.52|     400702|
2019-04       |2388792727.74|     371624|
2019-05       |2483675163.61|     412035|
2019-06       |2292360539.38|     399251| */


-- 5. GST - Monitor distribution of gst rate (0%, 10% and the rest)

select

	to_char(process_dte, 'YYYY-MM') as process_dte_ym,
	
	sum(case when abs(round(gstvalue/nullif(taxablevalue, 0),2)) = 0.1 then 1 end) as GST_10,
	
	sum(case when abs(round(gstvalue/nullif(taxablevalue, 0),2)) = 0 then 1 end) as GST_0,
	
	sum(case when abs(round(gstvalue/nullif(taxablevalue, 0),2)) != 0.1 and abs(round(gstvalue/nullif(taxablevalue, 0),2)) != 0 then 1 end) as GST_Others

from public.ap_tf

group by to_char(process_dte, 'YYYY-MM')

order by to_char(process_dte, 'YYYY-MM');

/* Result

process_dte_ym|count_gst_10|count_gst_0|count_gst_others|
--------------|------------|-----------|----------------|
2018-01       |      123063|     230326|           63693|
2018-02       |      110459|     198517|           66637|
2018-03       |      113118|     206920|           49806|
2018-04       |      110231|     217200|           81717|
2018-05       |      121112|     222234|           70471|
2018-06       |      114741|     203278|           68960|
2018-07       |      114100|     210602|           71618|
2018-08       |      125391|     218248|           71572|
2018-09       |      114535|     203441|           66417|
2018-10       |      129368|     219065|           70821|
2018-11       |      123968|     216666|           66105|
2018-12       |      121389|     210379|           62096|
2019-01       |      119055|     228657|           62843|
2019-02       |      116106|     200414|           63411|
2019-03       |      119770|     214894|           66038|
2019-04       |      113686|     196041|           61897|
2019-05       |      124793|     216169|           71072|
2019-06       |      120440|     213932|           64879| */


-- 6. Pos & Neg - Monior correlation of invoice amount and claim amount by months

select

	to_char(process_dte, 'YYYY-MM') as process_dte_ym,
	
	sum(case when totalinvamt > 0 then totalinvamt end) as sum_positive_amount,
	
	sum(case when totalinvamt < 0 then totalinvamt end) as sum_negative_amount,
	
	sum(case when totalinvamt > 0 then 1 end) as count_positive_amount,
	
	sum(case when totalinvamt < 0 then 1 end) as count_negative_amount,
	
	sum(case when totalinvamt = 0 then 1 end) as count_zero_amount,
	
	sum(case when totalinvamt is null then 1 end) as count_null_amount
	
from public.ap_tf

group by to_char(process_dte, 'YYYY-MM')

order by to_char(process_dte, 'YYYY-MM');

/* Result

process_dte_ym|sum_positive_amount|sum_negative_amount|count_positive_amount|count_negative_amount|count_zero_amount|count_null_amount|
--------------|-------------------|-------------------|---------------------|---------------------|-----------------|-----------------|
2018-01       |      2723779973.08|      -335172697.01|               348083|                68999|                 |                 |
2018-02       |      2669515029.58|      -336281193.90|               310501|                65112|                 |                 |
2018-03       |      2772952625.79|      -339012049.52|               301347|                68497|                 |                 |
2018-04       |      2514867164.13|      -482962844.14|               341281|                67867|                 |                 |
2018-05       |      2880146240.74|      -368604944.44|               344795|                69022|                 |                 |
2018-06       |      2715343767.66|      -399710300.83|               322231|                64748|                1|                 |
2018-07       |      2721754624.07|      -428010619.91|               326777|                69543|                 |                 |
2018-08       |      3008276929.41|      -372139195.24|               346213|                68999|                 |                 |
2018-09       |      2668086730.71|      -422730390.92|               316209|                68184|                 |                 |
2018-10       |      2987952097.93|      -363513872.42|               350672|                68582|                 |                 |
2018-11       |      3119102096.83|      -411357388.75|               337448|                69291|                 |                 |
2018-12       |      2897803762.72|      -435131568.35|               323584|                70280|                 |                 |
2019-01       |      2799345189.27|      -368953786.49|               340258|                70297|                 |                 |
2019-02       |      2670075535.29|      -363558785.31|               312971|                66960|                 |                 |
2019-03       |      3013025165.43|      -603454963.91|               330904|                69798|                 |                 |
2019-04       |      2755781146.46|      -366988418.72|               309134|                62490|                 |                 |
2019-05       |      2862701368.16|      -379026204.55|               344537|                67497|                1|                 |
2019-06       |      2827391947.95|      -535031408.57|               326240|                73011|                 |                 | */