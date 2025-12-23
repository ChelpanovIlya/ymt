export PS4=''
set -x
#ydb -p myydb tools dump -p bank_client -o migration_backup
#ydb -p myydb tools dump -p bank_account -o tmp
mv tmp/bank_account migration_backup/
rmdir tmp 
../bin/ymt -h localhost -U postgres -q "select inn as inn, full_name as name,id from client" -scheme migration_backup/bank_client/scheme.pb --hash-columns=id
../bin/ymt -h localhost -U postgres -q "select * from account" -scheme migration_backup/bank_account/scheme.pb --hash-columns=client_id
ydb -p myydb tools restore -i migration_backup/ -p .

