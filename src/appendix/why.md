# Why?

Why did we build Endatabas at all?
Isn't one of the many ([many](https://www.dbdb.io)) existing databases good enough?

## What is Endatabas, anyway?

The tagline "SQL Document Database With Full History" says a lot, but it doesn't say everything.
Endatabas is, first and foremost, an _immutable database_.
That's the Full History part.
But storing all your data, forever, has clear implications.

We consider these implications to be the _pillars_ of Endatabas.
In 3D geometry, the legs of a tripod are mutually supportive; as long as all three feet are in contact with the ground, the tripod will not wobble or collapse.
So it is with the pillars.
Each supports and implies the others.
The pillars are as follows:

* Full History (requires: immutable data and erasure)
* Timeline (requires: time-traveling queries)
* Separation of Storage from Compute (requires: light and adaptive indexing)
* Documents (requires: schemaless tables, "schema-per-row", arbitrary joins)
* Analytics (requires: columnar storage and access)

At the top of this five-dimensional structure is SQL, the lingua franca of database queries.
A window of time has recently opened when all of this is finally possible, together.
But first let's go back a few decades to see how we got here.

## History

None of the ideas in Endatabas are new.

George Copeland's [_What if mass storage were free?_](https://www.endatabas.com/references.html#10.1145/800083.802685)
asked, back in 1980, what an immutable database might look like.
His prescient vision for a database with full history enjoys the clarity of a researcher at the beginning of the database era.
People have occasionally asked of Endatabas, "why bother retaining all history?"
But this is the wrong question.
The real question is: "why bother destroying data?"
Copeland's answers, "The deletion concept was invented to reuse expensive computer storage."
The software industry has grown so accustomed to the arbitrary deletion historical data that we now take destroying data for granted.

Mass storage is not free yet — but it is cheap.
Copeland himself addresses "a more realistic argument: if the cost of mass storage were low enough, then deletion would become undesirable."
Any system that exploits the separation of storage and compute can enjoy these low costs.

An immutable dataset and a timeline of changing states are two sides of the same coin.
Previous states carry the innate property of time (whether defined by familiar wall clocks or versions or logical clocks).
Jensen and Snodgrass have thoroughly researched time-related database queries.
Much of their work was published [in the 1990s](https://www.endatabas.com/bibliography.html#10.1109/69.755613)
and early 2000s.
Storing time, querying across time, time as a value ... these challenging subjects eventually grew to form
[SQL:2011](https://www.endatabas.com/bibliography.html#ISO/IEC-19075-2:2021).
Most SQL databases have struggled to implement SQL:2011.
Incorporating _time_ as a core concept in mutable databases (those which support destructive updates and deletes) amplifies existing complexity.
Time should simplify the database, not complicate it.

Document databases have a more convoluted story.
Attempts at "schemaless", semi-structured, document, and object databases stretch from
[Smalltalk in the 1980s](https://www.endatabas.com/bibliography.html#10.1145/971697.602300)
to [C++ in the 1990s](https://en.wikipedia.org/wiki/Object_database#Timeline)
to [Java](https://prevayler.org/)
and [graphs](https://en.wikipedia.org/wiki/Neo4j) in the 2000s
to [JSON in the 2010s](https://en.wikipedia.org/wiki/MongoDB).
Despite all this, the most successful semi-structured document store, as of 2023, is a Postgres database with JSON columns.
Database users desire flexible storage and querying — but yesterday's weather says they desire SQL more.

SQL has four identities, four histories.
There is an SQL of academia, born of
[Codd's relational algebra (1970)](https://www.endatabas.com/references.html#10.1145/362384.362685) and
[Chamberlin/Boyce SEQUEL (1974)](https://www.endatabas.com/references.html#10.1145/800296.811515),
grown over decades with research like Snodgrass/Jensen's TSQL2.
Then there is the SQL of industry, the many-tentacled leviathan of IBM, Oracle, and Microsoft:
the SQL sold to businesses and governments, ceaselessly bifurcated into new dialects with each version and implementation.
Between these two rests the SQL of the ISO specification —
unified across 11 published standards, from SQL-86 to SQL:2023, spanning thousands of pages, adhered to by no single database.
Last, there is colloquial SQL, the language one refers to by the question, "do you know SQL?"
These four threads are intertwined across four decades, making it very difficult to clearly define what is meant by "SQL", even in very narrow contexts.
Colloquial SQL is perhaps of greatest interest to us.
This is the ubiquitous query language any new database must implement to succeed.

Khoshafian and Copeland introduced the [Decomposition Storage Model (DSM)](https://www.endatabas.com/bibliography.html#10.1145/318898.318923)
in 1985.
The four decades that followed saw any number of approaches to data analytics.
Most of the time, however, these demanded expensive data acrobatics:
data was piped, streamed, dumped, and copied into denormalized cubes and time-series databases.
As humanity grew out of the batch processing of the 1980s into the always-online society of the 2020s, analytics data became another form of operational data and parts of this pipeline were looped back to users and customers.
Hybrid Transactional/Analytical Processing (HTAP) promises a simpler, natural successor to OLTP and OLAP systems.
For many businesses, the transactional/analytical divide is as arbitrary as destroying data with every state change.

Humanity will arbitrarily destroy data in 2026 because hard disks were expensive in 1986.
We will wastefully query data with multiple systems in 2026 because CPUs were slow in 1986.

* [ ] SQLite
* [ ] Arrow = "not a free-for-all"
* [ ] pragmatism / elitism

## Timing

* [ ] incumbents

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
  removal of data, becomes opaque — removing data should keep tombstones
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
