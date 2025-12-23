export PS4=''
set -x
#rm -r type_test
#ydb -p myydb tools dump -p all_scalar_types -o type_test
#exit
../bin/ymt -h localhost -U postgres -q "select * from all_scalar_types" -scheme type_test/all_scalar_types/scheme.pb
ydb -p myydb tools restore -i type_test/ -p .
rm -r type_test_check
ydb -p myydb tools dump -p all_scalar_types -o type_test_check

