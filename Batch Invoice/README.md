Suppose you were receiving invoice report from client every month (batch). But unfortunately the report is not clean enough for your boss to read. Then he or she had you to analyze, to detect which invoices were paid, which were unpaid and which were missing from the newest batch.

**Features:**
+ Database: [PostgreSQL 12.1 64-bit](https://www.postgresql.org/download/)
+ Sample Script and Dataset: [Status Change.sql](https://github.com/ngtridung97/Sql/blob/master/Batch%20Invoice/Status%20Change.sql)
+ Sample Period: January 2020 - April 2020

See how it works below

### Prepare data
----------
**Create new table**
```sql
drop table if exists public.invoice_status;

create table public.invoice_status (

	invoice_id text,
	status text,
	batch text

);
```
**Insert values**
```sql		
insert into public.invoice_status (invoice_id, status, batch)

values

	('INV01', 'Paid', '202001'),
	('INV02', 'Paid', '202001'),
	('INV03', 'Paid', '202001'),
	('INV04', 'Unpaid', '202001'),
	('INV05', 'Unpaid', '202001'),
	('INV01', 'Paid', '202002'),
	('INV02', 'Paid', '202002'),
	('INV03', 'Paid', '202002'),
	('INV04', 'Unpaid', '202002'),
	('INV05', 'Paid', '202002'),
	('INV06', 'Unpaid', '202002'),
	('INV07', 'Unpaid', '202002'),
	('INV08', 'Unpaid', '202002'),
	('INV01', 'Paid', '202003'),
	('INV02', 'Paid', '202003'),
	('INV04', 'Unpaid', '202003'),
	('INV05', 'Paid', '202003'),
	('INV06', 'Paid', '202003'),
	('INV07', 'Unpaid', '202003'),
	('INV08', 'Unpaid', '202003'),
	('INV09', 'Unpaid', '202003'),
	('INV10', 'Unpaid', '202003'),
	('INV01', 'Paid', '202004'),
	('INV02', 'Paid', '202004'),
	('INV04', 'Paid', '202004'),
	('INV06', 'Paid', '202004'),
	('INV07', 'Unpaid', '202004'),
	('INV08', 'Unpaid', '202004'),
	('INV09', 'Paid', '202004'),
	('INV10', 'Paid', '202004'),
	('INV11', 'Unpaid', '202004'),
	('INV12', 'Unpaid', '202004'),
	('INV13', 'Unpaid', '202004');
```

### Main script
----------
Firstly, we observe dataset and should divide status column into 3 part:

1. Paid previously (appeared before our analysis).
2. Pending until now.
3. Unpaid into Paid.

**Get additional coulmns**
```sql
with

	invoice as (select *,
	
			row_number() over(partition by invoice_id order by batch desc) as rn,
			
			lag(status) over(partition by invoice_id order by batch) as prev_status,
	
			dense_rank() over (partition by invoice_id order by status asc) + dense_rank() over (partition by invoice_id order by status desc) - 1 as invoice_count
			
		from public.invoice_status),
```
**Paid invoices**
```sql

	closed as (select invoice_id, status, 'Paid from beginning' as note, batch as lastest_batch
	
		from invoice
		
		where status = 'Paid' and invoice_count = 1 and rn = 1),
```
**Unpaid invoices**
```sql
		
	pending as (select invoice_id, status, 'Pending' as note, batch as lastest_batch
	
		from invoice
		
		where status = 'Unpaid' and invoice_count = 1 and rn = 1),
```
**Unpaid to Paid invoices**
```sql
		
	change_status as (select a.invoice_id, a.status, a.batch as note, b.batch as lastest_batch
	
		from (select * from invoice where status = 'Paid' and invoice_count = 2 and status != prev_status) a
		
		inner join (select * from invoice where rn = 1) b
		
		on a.invoice_id = b.invoice_id)
```
**Union 3 above parts**
```sql
select * from closed

union

select * from pending

union

select * from change_status

order by 1;
```
**Sample result**
invoice_id|status|note               |lastest_batch|
----------|------|-------------------|-------------|
INV01     |Paid  |Paid from beginning|202004       |
INV02     |Paid  |Paid from beginning|202004       |
INV03     |Paid  |Paid from beginning|202002       |
INV04     |Paid  |202004             |202004       |
INV05     |Paid  |202002             |202003       |
INV06     |Paid  |202003             |202004       |
INV07     |Unpaid|Pending            |202004       |
INV08     |Unpaid|Pending            |202004       |
INV09     |Paid  |202004             |202004       |
INV10     |Paid  |202004             |202004       |
INV11     |Unpaid|Pending            |202004       |
INV12     |Unpaid|Pending            |202004       |
INV13     |Unpaid|Pending            |202004       |

According to result, there're 5 unpaid invoices and 8 paid invoices. INV03 and INV05 were removed from the lastest batch.

### Feedback & Suggestions
----------
Please feel free to fork, comment or give feedback to ng.tridung97@gmail.com