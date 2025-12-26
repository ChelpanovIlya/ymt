export PS4=''
set -x
ydb -p myydb yql -f ydb_drop_all_scalar_types.sql 
ydb -p myydb yql -f ydb_all_scalar_types.sql 
ydb -p myydb yql -f ydb_insert_all_scalar_types.sql 
rm -r type_test
ydb -p myydb tools dump -o type_test/ -p all_scalar_types

