# What is a RDBMS?

Think of a Relational Database Management System (RDBMS) as a vast collection of Excel workbooks.
Each workbook (in database terms, we call these "tables") contains different sheets, and on each
sheet, you have rows and columns of data. The sheets are organized in a way that the data can be
quickly searched, updated, inserted, or deleted.

A relational database consists of multiple tables that relate to each other. The relation between
tables is formed in the sense of shared columns.

## ACID

A transaction is a sequential group of statements or queries to perform single or multiple tasks in
a database. Transactions may consist of a single read, write, delete, or update operations or a
combination of these.

ACID – zbiór właściwości gwarantujących poprawne przetwarzanie transakcji w bazach danych

* Atomicity - każda transakcja albo zostanie wykonana w całości, albo w ogóle

* Consistency - po wykonaniu transakcji system będzie spójny, czyli nie zostaną naruszone zasady
  integralności (nie będzie nieautoryzowanych zmian).

* Isolation - jeśli dwie transakcje wykonują się współbieżnie, to ich efekt będzie taki jakby były
  wykonane sekwencyjnie

* Durability - jeśli transakcja się powiedzie, to zostaje ona utrwalona i aktualne dane są dostępne
  i spójne nawet pomimo możliwych awarii


## Schemas

Database schema is the structure of a database, refers to the organization of data as a blueprint
that demonstrates how the database is constructed. So, a database schema describes how the data may
relate to other tables or other data models. However, the schema does not actually contain data.

Database instance is a snap shot of data in a database at a single moment in time.


## Types of keys and their functions.

Keys help you to uniquely identify row of data in a table despite the size of the database, which
might contains thousand of records. It establishes and identify the relationship between tables.

* Primary key:
  - A field in a table that uniquely identifies each rows in a database table.
  - Primary keys must contain unique values.
  - A table can have only one Primary keys.

* Foreign key:
  - Reference a column in another table to define the relationship between two tables.
  - The relationship between 2 tables matches the Primary Key in one of the tables with a Foreign
    Key in the second table.

## Database Relationships

* 1-to-1
* 1-to-many
* many-to-many

## Database normalization

Normalization rules divide large tables into smaller tables and join them using relationships. The
purpose of normalization in SQL is:
* Eliminate redundant (repetitive) data
* Ensure that data is stored logically.

# SQL

SQL stands for "Structured Query Language". It's used to manage & query data stored in a
**relational database management system (RDBMS)**.

## What's the difference between SQL, SQLite, MySQL, PostgreSQL, and SQL Server?

People casually use "SQL" interchangeably with "MySQL" and "PostgreSQL". While that's not
technically correct, in most cases for beginners in the field, it doesn't matter too much unless you
want to be pedantic.

SQL is general, high-level language for querying and manipulating relational databases (RDBMS).
MySQL, Postgres, SQLite, and SQL Server are all RDBMS. You use varying flavors of SQL syntax to
query each unique RDBMS. For example, to query Postgres, you write PostgreSQL.

Here we use **PostgreSQL** because it is 2nd most popular, open source and extensible.

## PostgreSQL

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

* `SUM` adds together all the values in a particular column.
* `MIN` returns the lowest value in a particular column
* `MAX` returns the highest value in a particular column
* `AVG` calculates the average of a group of selected values.
* `COUNT` counts how many rows are in a particular column.

### `GROUP BY`

`GROUP BY` command tells the database to separate your data into groups, which can then be
aggregated independently.

```sql
SELECT 
	ticker, 
    AVG(open), 
    MAX(close)
FROM stock_prices
GROUP BY ticker
ORDER BY ticker;
```
You can `GROUP BY` two columns, even multiple columns, in SQL. To group by multiple categories, just
separate column names with commas


### `HAVING`

`HAVING` allows you to filter data based on values from aggregate functions (as opposed to `WHERE`
clause which filters BEFORE grouping).

```sql
SELECT ticker, AVG(open)
FROM stock_prices
GROUP BY ticker
HAVING AVG(open) > 200;
```

### `DISTINCT`

The `DISTINCT` SQL command is used in conjunction with the `SELECT` statement to return only
distinct (different) values.

```sql
SELECT DISTINCT manufacturer
FROM pharmacy_sales;
```

You can use DISTINCT with aggregate functions – the most common one being `COUNT`
```sql
SELECT COUNT(DISTINCT user_id) 
FROM trades;
```


### Math functions

* `ABS()`
* `ROUND()`
* `CEIL()`
* `FLOOR()`
* `POWER()`
* `MOD()`

### `CAST`

In SQL, integer division discards the remainder from the output, providing only the integer (whole
number) part of the result. You can still make SQL achieve decimal output with a few tricks such as:

* `CAST()` function
  ```sql
  SELECT 
  CAST(10 AS DECIMAL)/4,
  CAST(10 AS FLOAT)/4,
  10/CAST(6 AS DECIMAL),
  10/CAST(6 AS FLOAT); 
  ```

* multiplying by 1.0


### NULL

In SQL, NULL indicates the absence of a value. Unlike an empty string or zero, NULL doesn't
represent a specific value, but rather, a missing or unknown piece of information.

Now, to correctly identify NULL values, we can utilize the `IS NULL` or `IS NOT NULL` condition:
```sql
SELECT *
FROM goodreads
WHERE book_title IS NULL;
```

```sql
SELECT COALESCE(book_rating, 0)
FROM goodreads;
```
If column_name is NULL, it returns the specified 'expression'. Otherwise, it returns the value of
column_name.

`IFNULL()` function: Handles two arguments, returning the second if the first is null; else, it
returns the first.
```sql
SELECT book_title, IFNULL(book_rating, 0) AS rated_books
FROM goodreads;
```


### `CASE`

The `CASE` statement evaluates the specified conditions sequentially and returns a value when it
encounters the first true condition. If none of the conditions are met, the `ELSE` clause provides a
default value

* Using CASE-ELSE Clause with CASE Statement in SELECT Statement
  ```sql
  SELECT
    column_1,
    column_2, 
    CASE 
      WHEN condition_1 THEN result_1
      WHEN condition_2 THEN result_2
      WHEN ... THEN ...
      ELSE result_3 -- If condition_1 and condition_2 are not met, return result_3 in ELSE clause
    END AS column_3_name -- Give your new column an alias
  FROM table_1; 
  ```

* Filtering Conditions with `CASE` Statement in `WHERE` Clause
  ```sql
  SELECT 
    actor, 
    character, 
    platform
  FROM marvel_avengers
  WHERE 
    CASE 
      WHEN platform = 'Instagram' THEN followers >= 500000
      WHEN platform = 'Twitter' THEN followers >= 200000
      ELSE followers >= 100000
    END;
  ```

* Counting Results using SQL `COUNT()` in `CASE` Statement
  ```sql
  SELECT
  platform,
  COUNT(CASE 
    WHEN followers >= 500000 THEN 1
    ELSE NULL
  END) AS popular_actor_count,
  COUNT(CASE 
    WHEN followers < 500000 THEN 1
    ELSE NULL
  END) AS less_popular_actor_count
  FROM marvel_avengers
  GROUP BY platform;
  ```

* You can also use `SUM()`, `AVG()`

### JOINS

```sql
SELECT *
FROM artists
JOIN songs
  ON artists.artist_id = songs.artist_id;
```

`JOIN` keyword, which is short for an `INNER JOIN`. There are actually 4 different types of JOINS in
SQL.

| Type of Joins   | Description                                                                                                                                                              |
|-----------------|--------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| INNER JOIN      | Returns only the rows with matching values from both tables.                                                                                                             |
| LEFT JOIN       | Returns all the rows from the left table and the matching rows from the right table.                                                                                     |
| RIGHT JOIN      | Returns all the rows from the right table and the matching rows from the left table.                                                                                     |
| FULL OUTER JOIN | Returns all rows when there is a match in either the left or the right table. If there is no match, NULL values are returned for columns from the table without a match. |

### Date-time functions

* `CURRENT_DATE()` Returns today's date.
* `CURRENT_TIME()` Returns the current time without the date.
* `NOW()` Returns the current date and time.
* To retrieve records where a date is greater than or less than another date, you can use the > and
  < operators respectively.
  ```sql
  SELECT *
  FROM messages
  WHERE sent_date > '2022-08-10 00:00:00';
  ``` 

* `EXTRACT()` function extracts a specific component (i.e. year, month, day, hour, or minute)
  ```sql
  SELECT 
    message_id, 
    sent_date,
    EXTRACT(YEAR FROM sent_date) AS extracted_year,
    EXTRACT(MONTH FROM sent_date) AS extracted_month,
    EXTRACT(DAY FROM sent_date) AS extracted_day,
    EXTRACT(HOUR FROM sent_date) AS extracted_hour,
    EXTRACT(MINUTE FROM sent_date) AS extracted_minute,
  FROM messages
  LIMIT 3;
  ```

* `DATE_TRUNC()` rounds down a date or timestamp to a specified unit of time
* `INTERVAL` function is used to handle date and time gaps by adding and subtracting intervals such
  as "3 days", "5 hours", "45 minutes".
  ```sql
  SELECT 
    message_id,
    sent_date,
    sent_date + INTERVAL '2 days' AS add_2days,
    sent_date - INTERVAL '3 days' AS minus_3days,
    sent_date + INTERVAL '2 hours' AS add_2hours,
    sent_date - INTERVAL '10 minutes' AS minus_10mins
  FROM messages
  LIMIT 3;
  ```
* `TO_CHAR()` converts a date or timestamp to a string with a specified format.
* You can use casting for date and timestamp data too! If you encounter date or timestamp data
  that's   formatted as strings, here's two SQL functions that can help:
  - `::DATE` or `TO_DATE()`: Convert strings into dates.
  - `::TIMESTAMP` or `TO_TIMESTAMP()`: Convert strings into timestamps.
