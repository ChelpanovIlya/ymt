export PS4=''
set -x
set -e

rm -r migration_backup
#получим схему таблицы
ydb -p myydb tools dump -p countries -o migration_backup --scheme-only
#используем драйвер CSV для подготовки данных для импорта
../../bin/ymt --driver=CSV -q "select c2 as alpha2, nm as name_ru from countries" -s migration_backup/countries/scheme.pb
#проверяем данные
cat migration_backup/countries/data_00.csv
#импортируем данные
ydb -p myydb tools restore -i migration_backup/ -p .
#проверяем данные
ydb -p myydb yql --script "select * from countries"
