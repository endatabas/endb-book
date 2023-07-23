# Quickstart


## Installing

```sh
mkdir -p endb_data
docker pull endatabas/endb
docker run --rm -p 3803:3803 -v endb_data:/app/endb_data docker.io/endatabas/endb
```

See [tutorial/installation](/tutorial/installation.md) for more options to install and build `endb`.


## Try It!

```sh
curl -d "INSERT INTO cars (name, year) VALUES ('Toyota Tundra', DATE('2004-01-01'))" -H "Content-Type: application/sql" -X POST http://localhost:3803/sql
curl -d "SELECT * from cars" -H "Content-Type: application/sql" -X POST http://localhost:3803/sql
```

See [tutorial/drivers](/tutorial/drivers.md) for more ways to talk to `endb`.
