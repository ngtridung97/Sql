/* Assume that we have a PostgreSQL connection and want to monitor some useful information

Below queries are an overview for that request. */

-- 1. Data type for each column

select

	a.table_catalog, a.table_schema, a.table_name, a.column_name, a.is_nullable, a.data_type, a.udt_catalog, a.udt_schema, a.udt_name, a.is_generated, a.is_updatable,
	
	b.n_tup_ins, b.n_live_tup, b.last_autoanalyze

from information_schema.columns a

inner join pg_stat_user_tables b

on a.table_schema = b.schemaname and a.table_name = b.relname;

-- 2. Running queries

select

	a.pid, age(clock_timestamp(), a.query_start), a.usename, a.query,

	b.mode, b.locktype, b.granted
	
from pg_stat_activity a

inner join pg_locks b

on a.pid = b.pid 

where a.query != '<IDLE>' and a.query not like '%pg_stat_activity%'

order by b.granted, b.pid desc;