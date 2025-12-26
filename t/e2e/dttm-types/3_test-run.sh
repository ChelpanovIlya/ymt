export PS4=''
#set -x
clear

#{ set +x; echo "--------------------"; set -x;} 2>/dev/null
echo "--------------------"
../bin/ymt -U postgres -q "select * from all_dttm_types" -s dttm_type_test/all_dttm_types/scheme.pb
cat dttm_type_test/all_dttm_types/data_00.csv
ydb -p myydb tools restore -i dttm_type_test -p .
rm -r dttm_type_test_verify
ydb -p myydb tools dump -o dttm_type_test_verify -p all_dttm_types
cat dttm_type_test_verify/all_dttm_types/data_00.csv

echo "-------------------- --assume-timezone=local"
../bin/ymt -U postgres -q "select * from all_dttm_types" -s dttm_type_test/all_dttm_types/scheme.pb --assume-timezone=local
cat dttm_type_test/all_dttm_types/data_00.csv
ydb -p myydb tools restore -i dttm_type_test -p .
rm -r dttm_type_test_verify
ydb -p myydb tools dump -o dttm_type_test_verify -p all_dttm_types
cat dttm_type_test_verify/all_dttm_types/data_00.csv

echo "-------------------- --assume-timezone=+01:00"
../bin/ymt -U postgres -q "select * from all_dttm_types" -s dttm_type_test/all_dttm_types/scheme.pb --assume-timezone=+01:00
cat dttm_type_test/all_dttm_types/data_00.csv
ydb -p myydb tools restore -i dttm_type_test -p .
rm -r dttm_type_test_verify
ydb -p myydb tools dump -o dttm_type_test_verify -p all_dttm_types
cat dttm_type_test_verify/all_dttm_types/data_00.csv

echo "-------------------- --assume-timezone=+01:12"
../bin/ymt -U postgres -q "select * from all_dttm_types" -s dttm_type_test/all_dttm_types/scheme.pb --assume-timezone=+01:12
cat dttm_type_test/all_dttm_types/data_00.csv
ydb -p myydb tools restore -i dttm_type_test -p .
rm -r dttm_type_test_verify
ydb -p myydb tools dump -o dttm_type_test_verify -p all_dttm_types
cat dttm_type_test_verify/all_dttm_types/data_00.csv

echo "-------------------- --assume-timezone=xxx"
../bin/ymt -U postgres -q "select * from all_dttm_types" -s dttm_type_test/all_dttm_types/scheme.pb --assume-timezone=xxx
cat dttm_type_test/all_dttm_types/data_00.csv
ydb -p myydb tools restore -i dttm_type_test -p .
rm -r dttm_type_test_verify
ydb -p myydb tools dump -o dttm_type_test_verify -p all_dttm_types
cat dttm_type_test_verify/all_dttm_types/data_00.csv

