
curl -d 'SELECT 1' -H "Content-Type: application/sql" -X POST http://localhost:3803/sql

curl -d 'SELECT 1' -H "Content-Type: application/sql" -H "Accept: text/csv" -X POST http://localhost:3803/sql

curl -d 'SELECT 1 AS a' -H "Content-Type: application/sql" -H "Accept: text/csv" -X POST http://localhost:3803/sql

curl -v -d 'SELECT 1 AS a' -H "Content-Type: application/sql" -H "Accept: application/x-ndjson" -X POST http://localhost:3803/sql

curl -v -d 'SELECT 1 AS a' -H "Content-Type: application/sql" -H "Accept: application/ld+json" -X POST http://localhost:3803/sql

curl -v -d "SELECT DATE('2001-01-01') AS a" -H "Content-Type: application/sql" -H "Accept: application/ld+json" -X POST http://localhost:3803/sql

curl -d "q=SELECT%201" -H "Content-Type: application/x-www-form-urlencoded" -X POST http://localhost:3803/sql
curl -d "q=SELECT%201" -X POST http://localhost:3803/sql
curl -d "q=SELECT DATE('2001-01-01') AS a" -X POST http://localhost:3803/sql
curl -X GET "http://localhost:3803/sql?q=SELECT%201"

-- TODO: curl with file?

-- inserts --

curl -d "INSERT INTO users (name) VALUES ('steven')" -H "Content-Type: application/sql" -X POST http://localhost:3803/sql
curl -d "INSERT INTO users (name) VALUES ('hakan')" -H "Content-Type: application/sql" -X POST http://localhost:3803/sql -- fails
curl -d "SELECT * FROM users" -H "Content-Type: application/sql" -X POST http://localhost:3803/sql

-- create table --

curl -d "CREATE TABLE users (name TEXT)" -H "Content-Type: application/sql" -X POST http://localhost:3803/sql
curl -d "INSERT INTO users (name) VALUES ('steven')" -H "Content-Type: application/sql" -X POST http://localhost:3803/sql -- fails

-- select from nonexistant table --

curl -d "SELECT * FROM cars" -H "Content-Type: application/sql" -X POST http://localhost:3803/sql -- returns 409 conflict
