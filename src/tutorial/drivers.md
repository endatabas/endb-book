# Drivers

## HTTP / cURL

You can send SQL statements to `endb` over HTTP:

```sh
curl -d "INSERT INTO users (name) VALUES ('Deepthi')" -H "Content-Type: application/sql" -X POST http://localhost:3803/sql
curl -d "SELECT * FROM users -H "Content-Type: application/sql" -X POST http://localhost:3803/sql
```

[tutorial/http] has a detailed explanation of Content Types, Accept headers, and HTTP verbs.
