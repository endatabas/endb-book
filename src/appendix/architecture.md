# Architecture

## Immutable

All records in Endatabas are immutable.
Historical data is not lost when an `UPDATE` or `DELETE` statement is executed.
You can think of `endb` as one giant log of transactions
with fast queries made possible by [adaptive indexing](#adaptive-indexing).

## Erasure

The only time data in Endatabas is _truly_ deleted is with the `ERASE` statement.
This is used for user safety and compliance with laws like GDPR.

## Dynamic SQL

Both the heart and "UI" of Endatabas is a dynamic SQL engine which natively understands strongly-typed,
semi-structured rows (documents).
Here is an example to illustrate what that means:

```sql
INSERT INTO stores {brand: "Alonzo's Analog Synthesizers",
                    addresses: [{city: "New Jersey", country: "United States", opened: 1929-09-01},
                                {city: "Gottingen",  country: "Germany",       opened: 1928-09-01}]};

-- recursive query of nested document:
SELECT addresses..country FROM stores;
```

Endb SQL bases its core SQL dialect on SQLite.
It also draws inspiration from SQL:99, SQL:2011, SQL:2016, and SQL:2023.
Read more in our [bibliography](https://www.endatabas.com/bibliography.html).

## Columnar: Hybrid Transactional Analytic Processing (HTAP)

Endatabas stores and processes data as columns.
Endb's columnar storage is built on [Apache Arrow](https://arrow.apache.org/docs/format/Columnar.html).
Endb SQL allows users to retrieve data as documents.
The ultimate goal is for Endatabas to serve many (hybrid) purposes: day-to-day transactions and analytical jobs.

# Future

More detailed information about the future of Endb can be found in [the roadmap](roadmap.md).

## Columnar (OLAP) result sets

Endb does not yet support columnar data returned directly to the user.

## Cloud: Separation of Storage from Compute

If you're not sure what this is, think Amazon Aurora, Google AlloyDB, and Neon.
Compute nodes are the classic database (Postgres, MongoDB, etc.) — in an immutable world, these are just caches.
Storage is elastic object or blob storage (S3, Azure Blobs, etc.).

Endatabas is built to live in the clouds, alongside infinite disk.

Although the groundwork for separating storage from compute exists in Endb today,
elastic storage backends are not yet implemented.

## Adaptive Indexing

For more information on light and adaptive indexing, you can watch Håkan's talk from 2022:
["Light and Adaptive Indexing for Immutable Databases"](https://www.youtube.com/watch?v=Px-7TlceM5A)

Endb does not yet support adaptive indexing.
