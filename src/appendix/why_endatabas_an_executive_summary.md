# Why Endatabas? (An Executive Summary)

## What is Endatabas?

From the outside, Endatabas (or _Endb_) is an open source
SQL document database with full history.

On the inside, this means all records in Endatabas are immutable.
An `ERASE` statement is provided for compliance with laws and policies like GDPR.
Time-travel is possible, but Endb queries default to "as-of-now".
(AKA _The thing you want 97% of the time._)
Rows in Endb are "schema-last" documents and joins can be arbitrary, but queries are written in SQL.
Endb stores data in Apache Arrow: scalars are strongly typed, the on-disk format is columnar, and the execution engine understands rows and columns.
Endb separates storage from compute to provide unlimited disk space.

The dream of Endatabas is twofold:
Endb hopes to provide
[HTAP](https://en.wikipedia.org/wiki/Hybrid_transactional/analytical_processing),
so a secondary analytics database is not required for most users.
Endb plans to use AI
([adaptive indexing](https://www.endatabas.com/bibliography.html#YouTube-Raberg-Px-7TlceM5A))
to provide fast queries on cheap, elastic infrastructure.

## Why Endatabas?

After years of market research, the demand of database users is clear:
_"Stop making us babysit the database."_
After years of Computer Science research, it's also clear a sea change in database tech is due...
right about now.
(Give or take a decade. Our timing may be off.)

"Babysitting the database" can mean many things but they're all expensive and complex.
DBAs babysit Oracle indexes.
Developers babysit Postgres query optimizations.
Data engineers babysit ETL pipelines.
Analysts baybsit Redshift history.
SREs babysit Aurora costs.
Endb can't solve all these problems, but it attempts to be a jack-of-all-trades database that solves as many as it can.

Hellerstein and Stonebraker's [_What Goes Around Comes Around_](https://www.semanticscholar.org/paper/What-Goes-Around-Comes-Around-By-Michael-Hellerstein/2c701eae4bdc89f18eab1277b9c9a909841b2663)
remains true, decade after decade, since it was published in 2004.
As always, the relational data model is still king and SQL is still the lingua franca of databases.
Together, they assimilate new rivals every decade or so.
Endatabas tries to stand right at the center of this upcoming collapse of the data toolchain.

If we, as an industry, can drop a decade's vestigial growth in favour of a tighter, simpler solution?
Wonderful.
But what if we could shed a half-century's vestiges?
Perhaps event streams, relations, documents, graphs, temporal data, ETL and CDC can all live under one roof for many businesses.

Let's see.
We're not sure if we can make this work.
But it's exciting to try.

Clean. Simple. Less. A template for relational databases in 2060.

—
