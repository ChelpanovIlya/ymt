export PS4=''
set -x
#ydb -p myydb yql -f ydb_drop_all_dttm_types.sql 
ydb -p myydb yql -f ydb_all_dttm_types.sql 
#ydb -p myydb yql -f ydb_insert_all_dttm_types.sql 
[ -d dttm_type_test ] && rm -r dttm_type_test
ydb -p myydb tools dump -o dttm_type_test -p all_dttm_types --scheme-only

