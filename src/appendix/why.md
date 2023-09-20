# Why?

Why build Endatabas at all?
Isn't one of the many ([many](https://www.dbdb.io)) existing databases good enough?

## History

## Timing

outside => in:

* SQL
* immutable
* dynamic
* columnar
* cloud-first / SaaS
* open source

## Why SQL?

* "What other choice do you have?"
* 50 years of mindshare
* everyone knows SQL
* Spec is huge, but good
* designing a good query/programming language is a lifelong endeavour
* only successful 4GL
    * Lukas Eder: https://www.youtube.com/watch?v=wTPGW1PNy_Y

## Why "Full History"?

* also: Why Immutable Databases?
* archives, libraries
* SQL:2011
* "Why full history?" is the wrong question
    * reframe: "Why delete data on UPDATE?"
* useful for both userland and Ops

### Erasure, GDPR, and Privacy

* we always want to remember everything... except when we don't
* the current technology industry creates serious problems for privacy
* `DELETE`, when overloaded for saving disk space AND the explicit
  removal of data, becomes opaque -- removing data should keep tombstones
  so it's at least known that some data was removed

### Separation of Storage and Compute

* even traditional databases are embracing SvC, but only for ops
    * Aurora
    * AlloyDB
    * Neon
* required for a database that never deletes

## Why dynamic SQL?

* arguably a concomitant of "immutable records", but we'll keep it top-level
  because it is such a large topic on its own

### Why schemaless / dynamic?

* it is extremely difficult to give immutable tables schema while keeping it easy to use
* static schema has less and less meaning in a temporal (SQL:2011) world

### Why nested?

* SQL:99, SQL:2016, SQL:2023, PartiQL, Couchbase
* people do not decompose relational data into 6NF
    * nested data (JSON, XML) is already in use elsewhere in DBs, but it is foreign

## Why columnar?

* "One Database"
* Apache Arrow
* HTAP

## Why adaptive indexing?

* like schema, indexes are hard to define statically, in advance, when the database
  is immutable and all data lives on a timeline

## Third-Wave Commercial Open Source
