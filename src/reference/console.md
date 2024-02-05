# Console

A small console is provided to learn Endb SQL interactively
and run experimental queries.
It is distributed in the same Python package as the
[Python client](clients.md#python).

## Install

```sh
pip install endb
```

## Usage

```sh
endb_console
```

Show additional command line options with `endb_console --help`:

```
usage: endb_console [-h] [--url URL] [-u USERNAME] [-p PASSWORD] [sql ...]

positional arguments:
  sql                   SQL statement or file

options:
  -h, --help            show this help message and exit
  --url URL
  -u USERNAME, --username USERNAME
  -p PASSWORD, --password PASSWORD
```

When the Endb console starts, it will provide a multiline prompt (`->`)
where you can enter SQL statements and queries.
The prompt will extend onto new lines (`..`) until you enter a semicolon.

```sql
-> INSERT INTO users
.. {name: 'Conrad', email: 'c1o2n@shell.com'};
-> SELECT * FROM users;
```

The console has history which you can use the up and down arrows to navigate.

The console communicates with Endb over the [HTTP API](http_api.md).
Data is returned as LD-JSON documents and marshalled into strongly-typed Python
objects.

To quit, type `CTRL+D`.
