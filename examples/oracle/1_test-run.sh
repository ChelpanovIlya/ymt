export PS4=''
set -x
#set -e

rm -r migration_backup
ydb -p myydb yql -f drop-employe.sql
ydb -p myydb yql -f create-employe.sql

#получим схему таблицы
ydb -p myydb tools dump -p employe -o migration_backup

#используем драйвер Oracle для подготовки данных для импорта
export YMT_PASSWORD=tiger
../../bin/ymt -driver=Oracle --driver-options="service_name=XEPDB1" -h localhost -U scott \
--input-file=query.sql \
--scheme=migration_backup/employe/scheme.pb \
--assume-timezone=local \
--hash-columns=id,manager_id,department_id
#--limit 1 --print-record \

#проверяем данные
cat migration_backup/employe/data_00.csv
#импортируем данные
ydb -p myydb tools restore -i migration_backup/ -p .
#проверяем данные
ydb -p myydb yql --script "select * from employe"
