JDBC Foreign Data Wrapper for PostgresSQL
============================================

This is a foreign data wrapper (FDW) to connect [PostgreSQL](https://www.postgresql.org/)
to any Java DataBase Connectivity (JDBC) data source.

This is a fork of [pgspider/jdbc_fdw](https://github.com/pgspider/jdbc_fdw) to support FileMaker as a JDBC source.

Features:
  - Force `FETCH FIRST X ROWS ONLY` for `LIMIT` and `OFFSET X ROWS` for `OFFSET`
  - Output error message when there's an error to ease debugging

# Usage

```sql
CREATE EXTENSION jdbc_fdw;

-- Create the connection to the database
CREATE SERVER IF NOT EXISTS keesense_data FOREIGN DATA WRAPPER jdbc_fdw OPTIONS(
    drivername 'com.filemaker.jdbc.Driver',
    url 'jdbc:filemaker://192.168.132.67:2399/F3G_OCEAN_DATA',
    jarfile '/usr/share/java/fmjdbc.jar'
);

-- Define the user and password to use for the database
CREATE USER MAPPING IF NOT EXISTS FOR CURRENT_USER SERVER keesense_fm OPTIONS(username 'your_jdbc_user', password 'your_jdbc_password');

-- Map a FileMaker table to a postgresql foreign table
CREATE FOREIGN TABLE custodian (
    -- OPTIONS (key 'true') defines the primary key to help query optimizations and uniquely identify which rows to modify in UPDATE / DELETE operations
    "IdDep" NUMERIC OPTIONS (key 'true'),
    "NomReduit_lmt" TEXT,
    "NomDep_gst" TEXT
)
SERVER keesense_data
OPTIONS (table_name 'zDEP');
```
