# ymt — утилита миграции данных

Задачи миграции данных:
- сформировать файлы с данными из БД исходной системы,
- загрузить файлы в БД целевой системы.

Для загрузки данных при миграции будем использовать утилиту ydb CLI в режиме tools restore. 
Файлы для загрузки сформируем в необходимом для этого формате.

## Простой пример
Мы мигрируем данные по клиентам. Пусть в исходной системе на PostgreSQL данные хранятся в таблице client 
```sql
CREATE TABLE IF NOT EXISTS client (
    id        SERIAL PRIMARY KEY,
    inn       VARCHAR(12),
    full_name TEXT
);
INSERT INTO client (inn, full_name) values('1111111111','ООО "Ромашка"');
INSERT INTO client (inn, full_name) values('2222222222','ООО "Гвоздика"');
```

а в целеовой системе на YDB данные хранятся в таблице bank_client.
```sql
CREATE TABLE bank_client (
    id         Utf8,
    inn        Utf8,
    name       Utf8,
    PRIMARY KEY (id)
);
```

### Последовательность действий
- через ydb tools dump делаем dump таблицы bank_account без данных
```bash
ydb -p myydb tools dump -p bank_client -o migration_backup --scheme-only
```
в полученном результате нам нужен файл scheme.pb с описанием структуры таблицы.

- через ymt мы выполняем команду с запросом получения данных из исходной системы, 
  указывая в запросе алиасы полей, соответствующие целевым колонкам в новой системе.
```bash
ymt -h localhost -U postgres -q "select inn as inn, full_name as name from client" -scheme migration_backup/bank_client/scheme.pb 
Password for user 'postgres': 
Writing to: migration_backup/bank_client/data_00.csv
Wrote 2 records.
```
Программа ymt создает файл данных на основе схемы scheme.pb. Она берет информацию из результата запроса, размещает 
ее в нужных колонках и правильно форматирует. По умолчанию файл data_00.csv генерируется рядом с scheme.pb, где его будет ожидать 
команда ydb tools restore.

В результате создается файл data_00.csv с данными миграции
```
null,"1111111111","ООО+%22Ромашка%22"
null,"2222222222","ООО+%22Гвоздика%22"
```
с ним есть проблема — нет id. Добавим ключ `--add-id=id` для генерации id.
```bash
ymt -h localhost -U postgres -q "select inn as inn, full_name as name from client" -scheme migration_backup/bank_client/scheme.pb --add-id=id
```
теперь id есть
```
"7Ig15c_f8BGCR50MmZFEzA","1111111111","ООО+%22Ромашка%22"
"FpE15c_f8BGCR50MmZFEzA","2222222222","ООО+%22Гвоздика%22"
```
и можно загружать данные
```bash
ydb -p myydb tools restore -i migration_backup/ -p .
```
в результате данные загружены
```
ydb -p myydb 
myydb> select * from bank_client
┌──────────────────────────┬──────────────┬────────────────────┐
│ id                       │ inn          │ name               │
├──────────────────────────┼──────────────┼────────────────────┤
│ "7Ig15c_f8BGCR50MmZFEzA" │ "1111111111" │ "ООО "Ромашка""    │
├──────────────────────────┼──────────────┼────────────────────┤
│ "FpE15c_f8BGCR50MmZFEzA" │ "2222222222" │ "ООО "Гвоздика""   │
└──────────────────────────┴──────────────┴────────────────────┘
myydb>
```
## Миграция связанных таблиц
Дополним пример таблицей счетов.

В исходной БД
```sql
CREATE TABLE account (
    id              SERIAL PRIMARY KEY,
    client_id       INTEGER NOT NULL,
    account_number  VARCHAR(20) NOT NULL UNIQUE,
    currency        CHAR(3) NOT NULL DEFAULT 'RUB',
    balance         NUMERIC(19,2) NOT NULL DEFAULT 0,
    opened_at       TIMESTAMP NOT NULL DEFAULT NOW(),
    
    FOREIGN KEY (client_id) REFERENCES client(id) ON DELETE CASCADE
);
INSERT INTO account (client_id, account_number, currency, balance)
VALUES (1, '40702810123450000001', 'RUB', 150000.00);
INSERT INTO account (client_id, account_number, currency, balance)
VALUES (2, '40702810123450000002', 'RUB', 200000.00);
```
В целевой БД
```sql
CREATE TABLE account (
    id              Utf8,
    client_id       Utf8,
    account_number  Utf8,
    currency        Utf8,
    balance         Decimal(22, 2),  -- YDB поддерживает Decimal
    opened_at       Timestamp,
    PRIMARY KEY (id)
);
```
Сделаем dump целевой таблицы счетов и соберем таблицы в одной папке migration_backup
```bash
ydb -p myydb tools dump -p bank_account -o tmp --scheme-only
mv tmp/bank_account migration_backup/
rmdir tmp 
```
Выполним миграцию таблицы client. Используем параметр `--hash-columns=id` чтобы получить id в формате uuid на основе md5 hash значения.
```bash
ymt -h localhost -U postgres -q "select inn as inn, full_name as name,id from client" -scheme migration_backup/bank_client/scheme.pb --hash-columns=id
Password for user 'postgres': 
Writing to: migration_backup/bank_client/data_00.csv
Wrote 2 records.

cat migration_backup/bank_client/data_00.csv
"xMpCOKC5I4INzFCab3WEmw","1111111111","ООО+%22Ромашка%22"
"yB5yjZ1ML2NvBn-JzBSGLA","2222222222","ООО+%22Гвоздика%22"
```
Выполним миграцию таблицы account.
```
ymt -h localhost -U postgres -q "select * from account" -scheme migration_backup/bank_account/scheme.pb --hash-columns=client_id
Password for user 'postgres': 
Writing to: migration_backup/bank_account/data_00.csv
Wrote 2 records.

cat migration_backup/bank_account/data_00.csv
"1","xMpCOKC5I4INzFCab3WEmw","40702810123450000001","RUB",150000.00,2025-12-23 10:55:44.573548
"2","yB5yjZ1ML2NvBn-JzBSGLA","40702810123450000002","RUB",200000.00,2025-12-23 10:55:44.578789
```
Загрузим данные в целевую БД
```bash
ydb -p myydb tools restore -i migration_backup/ -p .
```

Проверим загруженные данные
```
ydb -p myydb
myydb> SELECT name, account_number, balance FROM bank_client JOIN bank_account  ON bank_client.id=bank_account.client_id;
┌────────────────────┬────────────────────────┬──────────┐
│ name               │ account_number         │ balance  │
├────────────────────┼────────────────────────┼──────────┤
│ "ООО "Ромашка""    │ "40702810123450000001" │ "150000" │
├────────────────────┼────────────────────────┼──────────┤
│ "ООО "Гвоздика""   │ "40702810123450000002" │ "200000" │
└────────────────────┴────────────────────────┴──────────┘
myydb>
```

## Заключительные положения

Генерация UUID-id сделана исходя из намерения иметь единый вид идентификаторов у всех сущностей. 
Если это не требуется — можно мигрировать значения существующих id.

Для генерации UUID в стандартном представлении xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx добавьте параметр `--std-uuid`.

Параметр --hash-columns можно применять к нескольким колонкам. Для этого нужно перечислить их 
через запятую, например `--hash-columns=addresses,contacts`. Значение каждой колонки будет 
преобразовано в идентификатор. Пригодится для массивов (коллекций).

Значения в колонках для --hash-columns могут быть текстовыми. Например, это могут быть наименования. 
Также вы можете в sql запросе комбинировать значения из нескольких полей записи таблицы.

SQL запрос может возвращать больше колонок, чем есть в целевой таблице. В таком случае ymt будет 
выводить в файл результата только те колонки, которые есть в целевой таблице.

SQL запрос может возвращать меньше колонок, чем есть в целевой таблице. Отсуствующие колонки будут
заполнены null.

Сопоставление колонок в SQL запросе и колонок в целевой таблице производится по названию колонки.

Команда tools restore загружает данные в режиме UPSERT. Если id не изменяются, повторная загрузка 
всего массива данных не создаст дубликатов. Существующие записи будут обновлены, а новые — добавлены.
Параметр --hash-columns обеспечивает неизменность id, если применяется к «стабильным» данным 
(например, к id в исходной системе). Параметр --add-id не обеспечивает этого, так как каждый раз 
генерируются новые значения id.

Значения полей временных типов YDB должны быть в UTC. Необходимую конвертацию нужно предусмотреть 
на уровне SQL запроса. ymt в текущей реализации конвертацию не выполняет.   

## Обработка значений даты и времени

Параметром --assume-timezone=TZ  можно включить режим приведения к UTC данных в полях типа Date, Datetime и Timestamp.
Значение TZ может быть "local" или "+HH:MM" или "-HH:MM". Если задано "local" -- используется системная TZ.
Если задано "+HH:MM" или "-HH:MM" -- используется указанный UTC offset.

Если режим приведения выключен, предполагается, что данные в полях типа Date, Datetime и Timestamp уже в UTC и они 
выводятся без добавления смещения с техническими корректировками формата для Datetime и Timestamp для обеспечения 
возможности их импорта в YDB:
- добавляется "T", если ее нет 
- добавляется "Z", если ее нет

2025-12-25 08:29:00 → 2025-12-25T08:29:00Z

Это дает возможность просто указать поля в select, без применения функций форматирования.

## Использование драйвера CSV

Драйвер позволяет использовать CSV файлы в качестве источника данных.

### Инсталляция драйвера CSV

Должны быть установлены средства сборки
```bash
sudo apt install build-essential perl-dev
```

Сам драйвер нужно установить командой:
```bash
cpan install Text::CSV_XS DBD::CSV
```

### Использование драйвера CSV

Для примера, нужно загрузить данные в таблицу countries
```sql
CREATE TABLE countries (
    alpha2    Utf8,
    alpha3    Utf8,
    numeric   Uint16,
    name_en   Utf8,
    name_ru   Utf8,
    is_active Bool DEFAULT true,
    PRIMARY KEY (alpha2)
);
```
и у нас есть файл с данными "countries":
```csv
c2,nm
RU,Российская Федерация
CN,Китайская Народная Республика
US,Соединённые Штаты Америки
```
В нем не все поля таблицы, но, допустим, для наших целей данных достаточно. Для импорта можно использовать драйвер CSV.
```bash
#получим схему таблицы
ydb -p myydb tools dump -p countries -o migration_backup --scheme-only
#используем драйвер CSV для подготовки данных для импорта
ymt --driver=CSV -q "select c2 as alpha2, nm as name_ru from countries" -s migration_backup/countries/scheme.pb
Writing to: migration_backup/countries/data_00.csv
Wrote 3 records.
#проверяем данные
cat migration_backup/countries/data_00.csv
"RU",null,null,null,"Российская+Федерация",null
"CN",null,null,null,"Китайская+Народная+Республика",null
"US",null,null,null,"Соединённые+Штаты+Америки",null
#импортируем данные
ydb -p myydb tools restore -i migration_backup/ -p .
#проверяем данные
ydb -p myydb
myydb> select * from countries
┌────────┬────────┬───────────┬─────────┬─────────────────────────────────┬─────────┐
│ alpha2 │ alpha3 │ is_active │ name_en │ name_ru                         │ numeric │
├────────┼────────┼───────────┼─────────┼─────────────────────────────────┼─────────┤
│ "CN"   │ null   │ null      │ null    │ "Китайская Народная Республика" │ null    │
├────────┼────────┼───────────┼─────────┼─────────────────────────────────┼─────────┤
│ "RU"   │ null   │ null      │ null    │ "Российская Федерация"          │ null    │
├────────┼────────┼───────────┼─────────┼─────────────────────────────────┼─────────┤
│ "US"   │ null   │ null      │ null    │ "Соединённые Штаты Америки"     │ null    │
└────────┴────────┴───────────┴─────────┴─────────────────────────────────┴─────────┘
myydb> 
#данные импортированы успешно
```

Вся обработка SQL для драйвера CSV выполняется посредством модуля [SQL::Statement](https://metacpan.org/pod/SQL::Statement). За более подробной информацией о возможностях обратитесь к документации [SQL::Statement](https://metacpan.org/pod/SQL::Statement). Среди них — соединения (joins), псевдонимы (aliases), встроенные функции и другие возможности. Описание поддерживаемого в DBD::CSV синтаксиса SQL приведено в [SQL::Statement::Syntax](https://metacpan.org/pod/SQL::Statement::Syntax).

Названия таблиц и колонок не чувствительны к регистру, если они не заключены в кавычки. Названия колонок будут очищены от непечатаемых или некорректных символов.

## Использование драйвера Oracle

### Инсталляция драйвера Oracle
Должны быть установлены средства сборки
```bash
sudo apt install build-essential perl-dev
```

Должен быть установлен Oracle client, например Instant Client. Нужно устанавить следующие части клиента:
- basic
- sdk
- sqlplus

Скачать [Instant client](https://www.oracle.com/database/technologies/instant-client/linux-x86-64-downloads.html) для Linux. Рекомендуется скопировать каталог с номером версии из поставки в /opt/oracle и создать симлинк /opt/oracle/instantclient на него. В каталоге нужно проверить корректность симлинков на библиотеки (маленкие .so файлы размером десятки байт должны быть симлинками на соответствующие "большие" файлы библиотек). При необходимости - удалить файлы-пустышки и создать симлинки на библиотеки.

Чтобы cpan мог найти Oracle client, нужно установить переменные окружения:
```bash
export ORACLE_HOME=/opt/oracle/instantclient
export LD_LIBRARY_PATH=/opt/oracle/instantclient:$LD_LIBRARY_PATH
export PATH=/opt/oracle/instantclient:$PATH
```
Рекомендуется настроить cpan на установку модулей локально для пользователя, чтобы избежать проблем с видимостью переменных окружения при установке через sudo.
```bash
perl -MCPAN -e 'my $c = "CPAN::HandleConfig"; $c->load(doit => 1, autoconfig => 1); $c->edit(prerequisites_policy => "follow"); $c->commit'
```

Сам драйвер нужно установить командой:
```bash
cpan install DBD::Oracle
```

### Использование драйвера Oracle

Смигрируем таблицу emp в схеме scott из Oracle в YDB. Структура целевой таблицы:
```sql
CREATE TABLE employe (
    id          Utf8,
    name        Utf8,
    job         Utf8,
    manager_id  Utf8,
    hire_dt     Date,
    salary      Decimal(22,9),
    comission   Decimal(22,9),
    department_id Utf8,
    PRIMARY KEY (id)
);
```
Запрос большой, указывать его в командной строке неудобно, запишем его в файл query.sql:
```sql
SELECT empno as id
    , ename as name
    , job
    , mgr as manager_id
    , hiredate as hire_dt
    , sal as salary
    , comm as comission
    , deptno as department_id 
FROM emp 
WHERE job='ANALYST'
```
Запускаем миграцию с помощью ymt:
```bash
#получим схему таблицы
ydb -p myydb tools dump -p employe -o migration_backup
#используем ymt с драйвером Oracle для подготовки данных для импорта
export YMT_PASSWORD=tiger
ymt -driver=Oracle --driver-options="service_name=XEPDB1" -h localhost -U scott \
--input-file=query.sql \
--scheme=migration_backup/employe/scheme.pb \
--assume-timezone=local
--hash-columns=id,manager_id,department_id
Converting date and time values to UTC using offset +03:00
Writing to: migration_backup/employe/data_00.csv
Wrote 2 records.
#проверяем данные
cat migration_backup/employe/data_00.csv
"hmx-4BPFjwH6FTqNMsntVw","SCOTT","ANALYST","uTc4Slc7lMTXzGAExJb5GQ",1987-07-12T21:00:00Z,3000,null,"mPE3CCEBlMR1aHvmEGo7hA"
"Zv4rzHAbtifhEb5oR6hDbA","FORD","ANALYST","uTc4Slc7lMTXzGAExJb5GQ",1981-12-02T21:00:00Z,3000,null,"mPE3CCEBlMR1aHvmEGo7hA"
#импортируем данные
ydb -p myydb tools restore -i migration_backup/ -p .
#проверяем данные
ydb -p myydb yql --script 'select * from employe'
┌───────────┬───────────────┬──────────────┬────────┬───────────┬────────────┬─────────┬────────┐
│ comission │ department_id │ hire_dt      │ id     │ job       │ manager_id │ name    │ salary │
├───────────┼───────────────┼──────────────┼────────┼───────────┼────────────┼─────────┼────────┤
│ null      │ "20"          │ "1987-07-12" │ "7788" │ "ANALYST" │ "7566"     │ "SCOTT" │ "3000" │
├───────────┼───────────────┼──────────────┼────────┼───────────┼────────────┼─────────┼────────┤
│ null      │ "20"          │ "1981-12-02" │ "7902" │ "ANALYST" │ "7566"     │ "FORD"  │ "3000" │
└───────────┴───────────────┴──────────────┴────────┴───────────┴────────────┴─────────┴────────┘
#данные импортированы успешно
```


## Отладочные параметры

--limit=N — ограничивает число выводимых данных. Дает возможность проверить запрос и конвертацию на 1-2 записях.

--print-scheme - выводит перечень колонок и их типов в scheme.pb 

--print-columns — выводит названия колонок в resultset вашего запроса. 

--print-record — выводит dump каждой записи resultset вашего запроса. Дает возможность проверить и названия колонок и данные.
