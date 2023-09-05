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

Both the heart and "UI" of Endatabas is a dynamic SQL engine which natively understands semi-structured rows (documents).

Endb SQL bases its core SQL dialect on SQLite.
It also draws inspiration from SQL:99, SQL:2011, SQL:2016, and SQL:2023.
Read more in our [bibliography](https://www.endatabas.com/bibliography.html).

## Cloud: Separation of Storage from Compute

If you're not sure what this is, think Amazon Aurora, Google AlloyDB, and Neon.
Compute nodes are the classic database (Postgres, MongoDB, etc.) — in an immutable world, these are just caches.
Storage is elastic object or blob storage (S3, Azure Blobs, etc.).

Endatabas is built to live in the clouds, alongside infinite disk.

## Columnar: Hybrid Transactional Analytic Processing (HTAP)

Endatabas stores and processes data as columns.
Endb SQL allows users to retrieve columns or documents.
The ultimate goal is for Endatabas to serve many (hybrid) purposes: day-to-day transactions and analytical jobs.

## Adaptive Indexing

For more information on light and adaptive indexing, you can watch Håkan's talk from 2022:
["Light and Adaptive Indexing for Immutable Databases"](https://www.youtube.com/watch?v=Px-7TlceM5A)
