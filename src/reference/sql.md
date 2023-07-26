# SQL Reference

TODO: This document isn't valid yet (objects are not supported).

Here is some Endb SQL:

```SQL
INSERT INTO people (id, name, friends)
  VALUES (5678, 'Steven',
          [{'user': 'Preethi'},
           {'user': 'Sandy'},
           {'user': 'Håkan'}]);

SELECT people.friends[2] FROM people;
```
