# Data Types

## Scalars

Endb supports the following native scalar types for now.
JSON-LD values with a type of `@json` are implicit and will be returned from Endb as JSON literals.
A `@value/@type` pair is not returned for a JSON literal.

| SQL         | JSON-LD            | Example Literal      | Description                           |
|-------------|--------------------|----------------------|---------------------------------------|
| `NULL`      | `@json`            | null                 |                                       |
| `VARCHAR`   | `@json`            | "hello"              | Unicode string                        |
| `BOOLEAN`   | `@json`            | FALSE                | 8-bit boolean                         |
| `INTEGER`   | `@json`            | 42                   | 32-bit two's complement integer (?)   |
| `REAL`      | `@json`            | 9007199254740992.123 | 64-bit IEEE 754 floating point number |
| `DECIMAL`   | `@json`            | 9007199254740992.123 | Unsupported, renders as `REAL`        |
| `BIGINT`    | `xsd:long`         | 9007199254740992     | 64-bit two's complement integer       |
| `TIMESTAMP` | `xsd:dateTime`     | 2007-01-01T00:00:00  | ISO microsecond precision timestamp   |
| `DATE`      | `xsd:date`         | 2007-01-01           | ISO date                              |
| `TIME`      | `xsd:time`         | 23:30:00             | ISO time                              |
| `BLOB`      | `xsd:base64Binary` | x'DEADBEEF'          | binary large object                   |

Depending on your programming environment, you may be accustomed to the following types: UUID, URI, Symbol, Keyword.
For now, please use a VARCHAR/string to represent these.
If you strongly feel you need a native representation of one of these types, email us: [hello@endatabas.com](mailto:hello@endatabas.com)
