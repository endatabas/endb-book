# Endb SQL

TODO: This document isn't valid yet (objects are not supported).

Here is some sample SQL:

```SQL
INSERT INTO posts (id, user_id, text)
  VALUES (1234, 5678, 'Hello World!');

SELECT * from posts;
```

Here is some eSQL:

```SQL
INSERT INTO people (id, name, friends)
  VALUES (5678, 'Steven',
          [{'user': 'Preethi'},
           {'user': 'Sandy'}]);

SELECT people.friends[2] FROM people;
```
