/* Assume that we have a sample record look like this

invoice_id|status|batch |
----------|------|------|
INV01     |Paid  |202001|
INV02     |Paid  |202001|
INV03     |Paid  |202001|
INV04     |Unpaid|202001|
INV05     |Unpaid|202001|
INV01     |Paid  |202002|
INV02     |Paid  |202002|
INV03     |Paid  |202002|

Sample description
	1. Dataset contains payment invoices status (Paid or Unpaid).
	2. Some invoices are missing from new batch.
	3. Unpaid invoice marked as "Pending", Paid invoice marked as batch value when status changed, Paid invoice from the beginning marked as "Paid from beginning"

The Manager wants to know current status of each invoice and detect which invoices are removed from the lastest batch. */


-- 1. Create sample data

drop table if exists public.invoice_status;

create table public.invoice_status (

	invoice_id text,
	status text,
	batch text

);

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


-- 2. Main script

with

	invoice as (select *,
	
			row_number() over(partition by invoice_id order by batch desc) as rn,
			
			lag(status) over(partition by invoice_id order by batch) as prev_status,
	
			dense_rank() over (partition by invoice_id order by status asc) + dense_rank() over (partition by invoice_id order by status desc) - 1 as invoice_count
			
		from public.invoice_status),

	closed as (select invoice_id, status, 'Paid from beginning' as note, batch as lastest_batch
	
		from invoice
		
		where status = 'Paid' and invoice_count = 1 and rn = 1),
		
	pending as (select invoice_id, status, 'Pending' as note, batch as lastest_batch
	
		from invoice
		
		where status = 'Unpaid' and invoice_count = 1 and rn = 1),
		
	change_status as (select a.invoice_id, a.status, a.batch as note, b.batch as lastest_batch
	
		from (select * from invoice where status = 'Paid' and invoice_count = 2 and status != prev_status) a
		
		inner join (select * from invoice where rn = 1) b
		
		on a.invoice_id = b.invoice_id)

select * from closed

union

select * from pending

union

select * from change_status

order by 1;

/* Result

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
INV13     |Unpaid|Pending            |202004       | */