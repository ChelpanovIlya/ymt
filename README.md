# ymt — YDB Migration Tool

Export data from any SQL database to YDB-compatible CSV dump format.

Ymt connects to a database, fetches data using a SQL query, and converts it into
the CSV dump format used by YDB. The resulting file can be loaded into a YDB table using
the ydb CLI "tools restore" command. Ymt can be used with any SQL-compatible
database with a Perl DBI driver installed. Over 50 SQL-compatible (or SQL-accessible)
databases can be used with Perl via DBI, thanks to native DBD:: modules and bridge
drivers like DBD::ODBC and DBD::JDBC.


## Features
- Supports PostgreSQL, MySQL, SQLite, Oracle, and any DB with DBI driver
- Generates YDB-ready CSV with proper escaping
- Adds synthetic UUIDs
- Validates non-text fields (no commas, quotes, newlines allowed)
- Fast import!

## Installation
### Prerequisites
- Perl 5.10+
- Required modules: DBI, Data::GUID, Digest::MD5, Term::ReadKey

### Install modules:
```bash
cpan install DBI Data::GUID Digest::MD5 Term::ReadKey
# or on Ubuntu/Debian:
sudo apt install libdbi-perl libdata-guid-perl libdigest-md5-perl libterm-readkey-perl
```

### Install ymt:
```bash
curl -L https://github.com/ChelpanovIlya/ymt/raw/main/bin/ymt > ~/bin/ymt
chmod +x ~/bin/ymt
```

### Install YDB CLI

### Usage:
```bash
ymt --help

ydb -p myydb tools dump -p users --scheme-only -o migration_backup
ymt -h pghost -U postgres --query="SELECT name as username,email FROM users" --scheme=migration_backup/users/scheme.pb --add-id=id
ydb -p myydb tools restore -i migration_backup -p .
```
Note: column aliases in the SQL query must match the column names of the YDB table.
