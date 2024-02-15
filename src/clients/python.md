# Python

The Python client library is used to communicate with an Endb instance
from a Python application.

[PyPI Package: `endb`](https://pypi.org/project/endb/)

## Install

```sh
pip install endb
pip install websockets  # optional WebSocket support
pip install pyarrow     # optional Apache Arrow support
```

## Usage Examples

**Import**

```python
from endb import (Endb, EndbWebSocket)
```

**Endb**

Use `Endb` to communicate with Endb over HTTP.
It accepts optional `url`, `accept`, `username`, and `password` parameters.
Accept headers default to LD-JSON and can be set to any valid
content type listed in the [HTTP API](../reference/http_api.md#accept-headers).
If you have `pyarrow` installed, you can also use `application/vnd.apache.arrow.file`
and `application/vnd.apache.arrow.stream`.

```python
e = Endb()
e = Endb('http://localhost:3803/sql')
e = Endb('http://localhost:3803/sql', 'text/csv')
e = Endb('http://localhost:3803/sql', 'application/json', 'zig', 'zag')
```

NOTE: Choosing accept headers other than LD-JSON will return
Python data structures symmetrical with those returned from
the respective accept header provided to the HTTP API.
`text/csv` returns comma-delimited strings, `application/json`
returns tuples as lists, and so on.

**EndbWebSocket**

Use the `EndbWebSocket` class to communicate with Endb over WebSockets.
It accepts optional `url`, `username`, and `password` parameters.

```python
ews = EndbWebSocket()
ews = EndbWebSocket('ws://localhost:3803/sql', 'zig', 'zag')
```

**sql()**

The `sql` method is available to both `Endb` and `EndbWebSocket`.
It accepts `q`, and optional `p`, `m`, and `accept` parameters
and returns an list of strongly-typed documents.
(See [Python API Reference](#python-api-reference).)

It is sychronous for `Endb` and asynchronous for `EndbWebSocket`.
To ignore the `p` or `m` parameters but still supply an accept header,
supply the default values or use a named (`accept`) parameter.

```python
from datetime import date, datetime, timezone
e.sql("INSERT INTO USERS (date, name, email) VALUES (?, ?, ?);", [datetime.now(timezone.utc), 'Aaron', 'aaron@canadahealth.ca'])
e.sql("INSERT INTO USERS (name) VALUES (?);", [['Aaron'], ['Kurt'], ['Cindy']], True)
e.sql("SELECT * FROM users;", [], False, 'text/csv')
e.sql("SELECT * FROM users;", accept = 'text/csv')
e.sql("INSERT INTO USERS (name) VALUES (?);", [['Aaron'], ['Kurt'], ['Cindy']], True, 'text/csv')
```

## Data Types

When an LD-JSON (default) accept header is used, strongly typed data is returned according to this mapping:

* `null` - `None`
* `xsd:date` - `datetime.date`
* `xsd:time` - `datetime.time`
* `xsd:dateTime` - `datetime.datetime`
* `xsd:base64Binary` - `bytes` (from `base64`)
* `xsd:integer` - `int`

For more information on Endb data types, see the
[Data Types doc](../reference/data_types.md).

## Complete Examples

```python
from endb import Endb
from datetime import date, datetime, timezone
e = Endb()
e.sql("INSERT INTO users {name: 'Yuvi'}")
e.sql("SELECT * FROM users;")

e2 = Endb('http://localhost:3803/sql', 'application/json', 'zig', 'zag')
e2.sql("INSERT INTO USERS (name) VALUES (?);", [['Aaron'], ['Kurt'], ['Cindy']], True, 'text/csv')
e2.sql("SELECT * FROM users;", [], False, 'application/json')
```

When the `websockets` dependency is installed, it is possible to
return asynchronous results to the Python interactive shell
directly if you start it with `python3 -m asyncio`:

```python
from endb import EndbWebSocket
ews = EndbWebSocket()
await ews.sql("INSERT INTO users {name: 'Lydia'}")
ws_result = await ews.sql("SELECT * FROM users;")
print(ws_result)

ews2 = EndbWebSocket(username = 'zig', password = 'zag')
await ews2.sql("INSERT INTO USERS (name) VALUES (?);", [['Aaron'], ['Kurt'], ['Cindy']], True, 'text/csv')
ws_result = await ews2.sql("SELECT * FROM users;", [], False, 'application/json')
print(ws_result)
```

## Python API Reference

NOTE: The following API documentation is generated from source code docstrings in the
[`endb` repository](https://github.com/endatabas/endb/tree/main/clients/python).

{{#include pydoc.md}}
