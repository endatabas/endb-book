# Intention

The goal of Endb's SQL dialect is to be small, coherent, and powerful.
The SQL specification is massive, with pages ordering in the thousands.
Rather than implement the entire SQL specification from scratch (a gargantuan task)
or mimic the SQL dialect of another database, Endb chooses a tiny core
and builds powerful, composable features on top of that.

This tiny core draws inspiration from many sources, but
[SQLite](https://www.sqlite.org/) in particular.
If SQLite supports a particular operator or function, Endb SQL also tries to.

Endb SQL also draws strong inspiration from the
[SQL specification](https://www.iso.org/standard/76583.html) itself
(and its [predecessors](https://en.wikipedia.org/wiki/SQL#Standardization_history))
and from [PostgreSQL](https://www.postgresql.org/).
Endb SQL's nested data is also heavily inspired by
[JSONPath](https://datatracker.ietf.org/doc/draft-ietf-jsonpath-base/),
[SQL/JSON](https://www.iso.org/standard/78937.html),
and their derivatives found in major SQL databases.

Light inspiration is drawn from
[PartiQL](https://partiql.org/),
[SQL++](https://www.couchbase.com/sqlplusplus/), and
[XQuery](https://www.w3.org/TR/xquery-30/).

For more information on Endb's influences, please see
[our bibliography](https://www.endatabas.com/bibliography.html).
