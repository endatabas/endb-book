# Data Types

## Scalars

Endb supports the following native scalar types for now.

JSON-LD values with a type of `@json` will be returned from Endb as JSON literals, verbatim.
The `@type` listed in parentheses is for reference purposes only.
JSON literal types are implicit so a `@value/@type` pair is not returned for a JSON literal.

| SQL         | JSON-LD                 | Example Literal      | Description                           |
|-------------|-------------------------|----------------------|---------------------------------------|
| `NULL`      | `@json`                 | null                 | Null, nil, undefined, or missing      |
| `VARCHAR`   | `@json` (`xsd:string`)  | "hello"              | UTF-8 string                          |
| `BOOLEAN`   | `@json` (`xsd:boolean`) | FALSE                | 8-bit boolean                         |
| `INTEGER`   | `@json` (`xsd:int`)     | 42                   | 32-bit two's complement integer (?)   |
| `REAL`      | `@json` (`xsd:double`)  | 9007199254740992.123 | 64-bit IEEE 754 floating point number |
| `BIGINT`    | `xsd:integer`           | 9007199254740992     | 64-bit two's complement integer, auto-promoted internally |
| `TIMESTAMP` | `xsd:dateTime`          | 2007-01-01T00:00:00  | ISO microsecond precision timestamp   |
| `DATE`      | `xsd:date`              | 2007-01-01           | ISO date                              |
| `TIME`      | `xsd:time`              | 23:30:00             | ISO time                              |
| `BLOB`      | `xsd:base64Binary`      | x'DEADBEEF'          | Binary large object                   |

[SQL Data Types](../sql/data_types.md) are covered in detail in the SQL Reference.

## Collections

| SQL         | JSON-LD            | Example Literal                      | Description                 |
|-------------|--------------------|--------------------------------------|-----------------------------|
| `ARRAY`     | `@json`            | `["Joe", "Dan", "Dwayne"]`           | Zero-based array            |
| `OBJECT`    | `@json`            | `{n: 3, b: 2023-01-01}`              | Object, map, dict, document |

## Limited and Unsupported Scalar Types

| SQL         | JSON-LD                | Example Literal                      | Description                                                                |
|-------------|------------------------|--------------------------------------|----------------------------------------------------------------------------|
| `DECIMAL`   | `xsd:decimal`          | 9007199254740992.123M                | Arbitrary precision decimal. Limited support. Use 2 `BIGINT`s or `VARCHAR` |
| `NUMERIC`   | `xsd:integer`          | -123456789012345678901234567890N     | Arbitrary precision integer. Unsupported. Use `VARCHAR`                    |
| `URI`       | `xsd:anyURI`           | https://endb.io                      | Uniform Resource Identifier. Unsupported. Use `VARCHAR`                    |
| `UUID`      | `@json` (`xsd:string`) | a81bc81b-dead-4e5d-abff-90865d1e13b1 | 128-bit Universally Unique Identifier. Unsupported. Use `VARCHAR`          |

If you strongly feel you need a native representation of one of these types, email us: [hello@endatabas.com](mailto:hello@endatabas.com)
