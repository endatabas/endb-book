# Why?

Why did we build Endatabas (aka Endb) at all?
Isn't one of the many ([many](https://www.dbdb.io)) existing databases good enough?

Many incumbent databases serve their use cases and markets well.
But the demands placed on databases are growing rapidly.
These demands pull in multiple directions, all at once, and existing technology cannot support them without introducing enormous complexity.
Dramatic change is required.

Endb takes good ideas and makes them easier to access, while reducing operational headache.
It does not try to be flashy or unnecessarily revolutionary.
Instead, it tries to be simple and familiar on the surface while providing a lot of new power under the covers.

Let's talk about what that means in clear, concrete terms.

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
The software industry has grown so accustomed to the arbitrary deletion of historical data that we now take destroying data for granted.

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
and [graphs in the 2000s](https://en.wikipedia.org/wiki/Neo4j)
to [JSON in the 2010s](https://en.wikipedia.org/wiki/MongoDB).
Despite all this, the most successful semi-structured document store, as of 2023, is a Postgres database with JSON columns.
Database users desire flexible storage and querying — but yesterday's weather says they desire SQL more.
Can't we have both?

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
Colloquial SQL is of greatest interest to us.
This is the ubiquitous query language any new database must implement to succeed.

Khoshafian and Copeland introduced the [Decomposition Storage Model (DSM)](https://www.endatabas.com/bibliography.html#10.1145/318898.318923)
in 1985.
The four decades that followed saw any number of approaches to data analytics.
Most of the time, however, these demanded expensive data acrobatics:
data was piped, streamed, dumped, and copied into denormalized cubes and time-series databases.
As humanity grew out of the batch processing of the 1980s into the always-online society of the 2020s, analytics data became another form of operational data and this pipeline was looped back to users and customers.
Hybrid Transactional/Analytical Processing (HTAP) promises a simpler, natural successor to OLTP and OLAP systems.
For many businesses, the transactional/analytical divide is as arbitrary as destroying data with every state change.

Humanity will arbitrarily destroy data in 2026 because hard disks were expensive in 1986.
Similarly, we will wastefully query data with multiple systems in 2026 because CPUs were slow in 1986.

## Why SQL?

When you approach Endb from a distance, you won't see the pillars at first.
You'll see the structure they support.
This structure also binds the pillars together.
The query language of a database is its glue.
It is the user interface.
It defines the user experience.
It is at once a programming language, a dialogue, an envelope, a protocol.
But a query engine is not divorced from its query language, and so the language choice also informs system design and behaviour.

There are mundane reasons for choosing SQL.
If asked "do you know SQL?" there's a high probability the answer is "yes."
SQL is the language of data science and third-party tools.
If any sufficiently successful database has to provide SQL access anyway, one may as well start there.

But this is not why we chose SQL.
We believe SQL can be beautiful.

As mentioned in [_History_](#history), we are primarily concerned with colloquial SQL.
The other threads of SQL are relevant but Endb will never implement the entire SQL specification.
Instead, the Endb SQL dialect unifies the pillars under one strongly-dynamically-typed umbrella, a variation of the SQLite dialect.
SQLite's applications are quite different from those of Endatabas, so Endb SQL is not weakly-typed and Endb types are not a free-for-all.
Instead, Endb internally adopts types from [Apache Arrow](https://arrow.apache.org/), which it uses as a storage medium.

When considering alternatives, there are no contenders.
Cypher, Datalog, MongoDB query documents, and other schemaless query languages work well for one database implementation but lack both mindshare and standards.
PartiQL, SQL++, and other NewSQL languages that depart from SQL suffer precisely because they are _almost_ SQL;
each feels a bit like [Adriano Celentano singing in synthetic American English](https://www.youtube.com/watch?v=-VsmF9m_Nt8).
One can fantasize about designing a query language from scratch but not only is this a lifelong endeavour, it's very easy to get wrong.

Just as PL/SQL and T-SQL differ, so will Endb SQL from other dialects.
However, colloquial SQL is comparable to colloquial Hindi — at higher levels, it bifurcates into Urdu and Sanskrit but speakers of both lineages understand one another.
[Endb SQL will be familiar](../tutorial/sql_basics.md) to users of other SQL dialects.

With its long, rich history SQL not only has the necessary theoretical underpinnings but the battle scars of technology that lasts.
It sits alongside TCP/IP, zip files, LISP, C, and the QWERTY keyboard layout.
It will see its centenary.

## Why Full History?

Even if we ignore Copeland's dream of mass storage from 1980, it is easy to see why destroying data is harmful.
To destroy data is to destroy facts — to lie about the truth of what happened.

Few modern systems permit the total destruction of data for this obvious reason.
Some choose to create audit tables: `users_audits`, `sales_audits`, and so on.
Some choose to log anything and everything.
"It's on disk somewhere."
If a company is particularly broken, it will extract metrics from logs to create invoices and reports.

Industries which take their data very seriously (banking, healthcare) already store immutable records.
They just do so in a mutable database.
Append-only tables are not new, but they're an order of magnitude easier to work with — for both users and operators — if the database is append-only from the ground up.

These same industries will resist the destruction of data unless absolutely necessary, but they will bend to necessity.
[Erasure](../sql/data_manipulation.html#erase) is concomitant with immutability — we cannot have one without the other.
The existing designs of databases create serious problems for privacy.
`DELETE`, when overloaded to mean both "save disk space" and "explicitly remove this data", becomes opaque.
It does not leave any queryable record of the deletion.
Removing data should keep tombstones so it's at least known that some data was removed.

## Why a timeline?

Keeping your data's entire history is the write-side of the equation.
If you didn't care about getting this data back, you could just dump it into an unintelligible pile.
But you not only want your data back, you want to query it in the easiest way possible.

One very sensible way to see and query immutable data is along a timeline.
Endb makes no assumptions about your desire to participate in this timeline.
By default, everything is visible _as-of-now_ but querying the past should feel effortless.

```sql
-- without time travel:
SELECT * FROM products;
-- time travel to 2020:
SELECT * FROM products FOR SYSTEM_TIME AS OF 2020-08-25T00:00:00;
```

## Why Separation of Storage and Compute?

// TODO: , AlloyDB, or Neon ... probably don't bother mentioning?

Separating storage from compute is an implementation detail.
AWS customers don't choose Amazon Aurora because they're craving this separation.
Decoupling storage from compute makes scale (both up and down) trivial.
It also introduces the possibility of
["reducing network traffic, ... fast crash recovery, failovers to replicas without loss of data, and fault-tolerant, self-healing storage."](https://assets.amazon.science/dc/2b/4ef2b89649f9a393d37d3e042f4e/amazon-aurora-design-considerations-for-high-throughput-cloud-native-relational-databases.pdf)

For every Postgres operator who's ever fought with `repmgr`, we want Endatabas to be seamless by comparison.

This decoupling is concomitant with [Light and Adaptive Indexing](https://www.youtube.com/watch?v=Px-7TlceM5A).
It is undesirable to manually construct expensive indexes for unknown future schemas over (effectively) infinite data.
Instead, we should let machine learning handle this job.

## Why documents?

It can be argued that "why documents?" is really multiple questions:
why schemaless?
why nested data?
why dynamic SQL?

First, the challenges.
It is extremely difficult to force global schema onto every row in a table in an immutable world.
Even if there were a simple mechanism in SQL to alter table schema only for certain durations (there isn't), the database user would still be burdened with querying based on a particular schema at a particular time in the history of the table.
This complexity is compounded by the fact that static schemas have less and less meaning in a temporal world.
Endb introduces [SQL:2011 time-travel and period predicates](https://docs.endatabas.com/sql/time_queries.html).
The difficulty, mentioned earlier, that other databases encounter when introducing SQL:2011 is twofold: dealing with "time" in a world where history can be violently rewritten and managing an unbending schema across time.

Nested data is equally unnatural in incumbent databases.
SQL:99, SQL:2016, SQL:2023, PartiQL, and SQL++ (Couchbase) all offer some way of shoehorning nested data into flat tables.
Not only will no one ever decompose relational data into 6NF, it is unlikely we'll ever see a return to the classic BCNF of business entity-relationship diagrams.
Nested data is here to stay.
Foreign, embedded JSON (or XML) is little more than a band-aid.
Nested data should be native.

Second, the joys.
Schema-per-row can be incredibly liberating.
Not only does this feel more natural, it embraces the messy truth of the real world.
Schema-on-write can be added later, when the business is ready to lock down what it knows about a domain.
But many use cases _demand_ flexible schemas.
What if this week's project requires downloading huge amounts of semi-structured JSON pricing data from the APIs of competing online stores to compare them?
Endb can handle this case out of the box.
Most databases would require a great deal of manipulation first.

Dynamic SQL is required to support schemaless, nested data — but it also brings its own joys.
When dynamic SQL rests on top of a flexible data model which can ingest any data,
it is capable of exploring nested data and easily constructing arbitrary joins users could normally only construct in a graph database.

## Why "One Database"?

It is often the job of analytics databases to record and query all the data of a business, denormalized for speed.
There will always be analytical jobs which require data to be transformed.
But for decades, many businesses allow data scientists, analysts, and even CEOs read-only access to an OLTP replica.

[HTAP may be right on the horizon](https://www.scattered-thoughts.net/writing/a-shallow-survey-of-olap-and-htap-query-engines/),
but ad-hoc analytical queries are run on a copy of most production databases today anyway.
Endb already has all the business data, which can be read from easy-to-produce, cheap, ephemeral read replicas.

## Why Commercial Open Source?

At this stage in humanity's development, it's hard to imagine many new projects or business units actively choosing closed-source or proprietary infrastructure.
If a business is already locked into a Microsoft or Amazon toolchain, it may have no choice.
But we believe people will not buy new proprietary data products, since we certainly wouldn't.

## Why Now?

All of the pillars outlined above have their own strike-when-the-iron-is-hot moment.
The SQLite we know today began to materialize in 2001.
Amazon S3 was launched in 2006.
MongoDB was first released in 2007.
Immutable data and functional programming reached the mainstream in the 2010s.
Datomic (arguably the first immutable OLTP database) was release in 2012.
Amazon Aurora was released in 2015 and Google's AlloyDB in 2022.
Apache Arrow saw its first release in 2016.
Many financial firms began building their own temporal databases around 2020.
SQL:2011, SQL:2016, and SQL:2023 were ratified in their respective eponymous years.
HTAP hasn't quite happened yet.
AI-driven indexes haven't quite happened yet.

The moment for something like Endatabas is now... but it is a very long moment.
Endatabas cannot be built in a Postgres-compatible fashion.
It cannot be constructed from components of SQLite (we tried).
It's time for something new.
