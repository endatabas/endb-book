# endb module

### *class* endb.Endb(url='http://localhost:3803/sql', accept='application/ld+json', username=None, password=None)

Bases: `AbstractEndb`

An Endatabas client for the HTTP API

#### url

HTTP URL of an Endatabas instance

* **Type:**
  str

#### accept

Accept header content type

* **Type:**
  str

#### username

Username for HTTP Basic Auth

* **Type:**
  str

#### password

Password for HTTP Basic Auth

* **Type:**
  str

#### sql(q, p=[], m=False, accept=None)

Executes a SQL statement

The SQL statement is sent to Endb.url over HTTP.

* **Parameters:**
  * **q** (*str*) – SQL statement or query to execute
  * **p** (*array_like* *,* *default=* *\[* *\]*) – Positional or named SQL parameters (or an array of either, if using many parameters)
  * **m** (*bool* *,* *default=False*) – Many parameters flag
  * **accept** (*str* *,* *optional*) – Accept header content type (defaults to Endb.accept)
* **Raises:**
  **TypeError** – Internal error if attempting to translate an unknown type
      to LD-JSON.

### *class* endb.EndbWebSocket(url='ws://localhost:3803/sql', username=None, password=None)

Bases: `AbstractEndb`

An Endatabas client for the HTTP API

#### url

HTTP URL of an Endatabas instance

* **Type:**
  str

#### username

Username for HTTP Basic Auth

* **Type:**
  str

#### password

Password for HTTP Basic Auth

* **Type:**
  str

#### *async* close()

Closes the WebSocket connection

#### *async* sql(q, p=[], m=False, accept=None)

Executes a SQL statement

The SQL statement is sent to Endb.url over WebSockets.

* **Parameters:**
  * **q** (*str*) – SQL statement or query to execute
  * **p** (*array_like* *,* *default=* *\[* *\]*) – Positional or named SQL parameters (or an array of either, if using many parameters)
  * **m** (*bool* *,* *default=False*) – Many parameters flag
  * **accept** (*str* *,* *optional*) – Ignored. WebSocket communication is always in LD-JSON.
* **Raises:**
  * **AssertionError** – If ‘id’ of request and response do not match.
  * **RuntimeError** – If response from server contains an error.
