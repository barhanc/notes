# SQL

SQL stands for "Structured Query Language". It's used to manage & query data stored in a
**relational database management system (RDBMS)**.

## What is a RDBMS?

Think of a Relational Database Management System (RDBMS) as a vast collection of Excel workbooks.
Each workbook (in database terms, we call these "tables") contains different sheets, and on each
sheet, you have rows and columns of data. The sheets are organized in a way that the data can be
quickly searched, updated, inserted, or deleted.

## ACID

ACID – zbiór właściwości gwarantujących poprawne przetwarzanie transakcji w bazach danych

* Atomicity - każda transakcja albo zostanie wykonana w całości, albo w ogóle

* Consistency - po wykonaniu transakcji system będzie spójny, czyli nie zostaną naruszone zasady
  integralności (nie będzie nieautoryzowanych zmian).

* Isolation - jeśli dwie transakcje wykonują się współbieżnie, to ich efekt będzie taki jakby były
  wykonane sekwencyjnie

* Durability - jeśli transakcja się powiedzie, to zostaje ona utrwalona i aktualne dane są dostępne
  i spójne nawet pomimo możliwych awarii

## What's the difference between SQL, SQLite, MySQL, PostgreSQL, and SQL Server?

People casually use "SQL" interchangeably with "MySQL" and "PostgreSQL". While that's not
technically correct, in most cases for beginners in the field, it doesn't matter too much unless you
want to be pedantic.

SQL is general, high-level language for querying and manipulating relational databases (RDBMS).
MySQL, Postgres, SQLite, and SQL Server are all RDBMs. You use varying flavors of SQL syntax to
query each unique RDBMS. For example, to query Postgres, you write PostgreSQL.

Here we use **PostgreSQL** because it is 2nd most popular, open source and extensible.

## PostreSQL

### Basics

* `BETWEEN` is a logical operator that selects values within a given range (**inclusive**)
  ```sql
  SELECT column_name(s)
  FROM table_name
  WHERE column_name BETWEEN value1 AND value2;
  ```

* The `IN` operator allows us to specify multiple values in a single line's `WHERE` clause, instead
  of the more tedious approach of having to use multiple OR conditions to filter for multiple
  values.
  ```sql
  SELECT ...
  FROM ...
  WHERE column IN (..., ...);
  ```

* Single quotes are used to indicate the beginning and end of a string in SQL. Double quotes
  generally aren't used in SQL, but that can vary from database to database. Stick to using single
  quotes.
  
* Here's the syntax for `LIKE`:
  ```sql
  SELECT ...
  FROM ...
  WHERE column LIKE ... ;
  ```
  `LIKE` is often accompanied with wildcards %  (zero or multiple characters) and _ (single
  character).

* Theoretically, rows in a relational database such as Postgres, MySQL, SQL Server, etc. aren't
  stored in any particular or guaranteed sort order. In fact, executing an identical `SELECT *`
  query twice on the same dataset doesn't ensure the results will come back in the same order.

* In SQL, the `ORDER BY` clause allows you to reorder your results based on the data in one or more
  columns.
  ```sql
  SELECT column1, column2
  FROM table_name
  WHERE condition(s)
  ORDER BY column;
  ```
  To reverse the default ascending sort order for `ORDER BY`, you can use the `DESC` SQL keyword.
  The `ORDER BY` clause doesn't just work with one column – you can sort on two, or even multiple
  columns

  Pro tip: you can substitute numbers for column names in the ORDER BY clause. The numbers
  correspond to the columns you specify in the SELECT clause (**starting from 1**).

* `LIMIT` and `OFFSET` are used for limiting the output
  ```sql
  SELECT * 
  FROM callers
  ORDER BY call_received DESC
  LIMIT 5;
  ```
  will get you the 5 most recent phone calls received, while here
  ```sql
  SELECT * 
  FROM callers
  ORDER BY call_received DESC
  OFFSET 10
  LIMIT 5;
  ```
  we skip the first 10 phone calls and fetch the subsequent 5 phone calls received.

### Aggregate functions