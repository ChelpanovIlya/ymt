export PS4=''
set -x
psql -U postgres -f pg_all_scalar_types.sql 
psql -U postgres -f pg_insert_all_scalar_types.sql 

