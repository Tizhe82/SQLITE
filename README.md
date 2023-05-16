# Welcome to My Sqlite
***

insert into db.csv (a_k,b_k,c_k) values (a_v, c_v, c_v);
insert into db.csv values (a_v, c_v, c_v);
select * from db.csv;


UPDATE db.csv SET a_k = 'a_nv', b_k = 'b_nv' WHERE c_k = 'c_v';
DELETE FROM db.csv WHERE a_k = 'a_nv';
SELECT a_k,b_k FROM db.csv;

SELECT * FROM database.csv;
INSERT INTO database.csv (firstname,email,blog) VALUES (John, john@johndoe.com, https://blog.johndoe.com);


select * from nba_players.csv;
select height, weight from nba_players.csv;
## Task
The task is to replicate the behavior of the SQLite app.\
The goal is to create a class called MySqliteRequest that\
answers SQL requests like the original SQLite and\
a command line interface for it.

## Description
The class has methods for:\
SELECT, FROM, WHERE, JOIN, ORDER, INSERT, VALUES, UPDATE, and DELETE.\

my_sqlite_cli.rb: This script is responsible for implementing the CLI.\
It reads user input with readline(), performs parsing on it and\
calls the appropriate methods from MySqliteRequest.

my_sqlite_request.rb: This script contains the library.

peer_review_questions.rb: Tests for peer reviewing ease.

## Installation
Requirements: Ruby version 2.7 or higher.\
csv library to read CSV files.\
readline library to implement the CLI.

Clone this repository and navigate to the root directory.\
Run the following command: ruby my_sqlite_cli.rb.\
This will start the command-line interface.

## Usage
To use the CLI:
Run the `ruby my_sqlite_cli.rb` command in your terminal,\
which will open the interface. Then you can enter SELECT, INSERT, UPDATE\
and DELETE queries with optional WHERE and JOIN clauses to interact with\
SQLite-like database created using the `MySqliteRequest` class.
Type quit to exit the CLI.

```
$> ruby my_sqlite_cli.rb
my_sqlite_cli> INSERT INTO students (name,age) VALUES (Bob, 23)
my_sqlite_cli> SELECT * FROM students
name|age
--------
Bob|23
my_sqlite_cli> INSERT INTO students VALUES (John,25)
my_sqlite_cli> SELECT name, age FROM students WHERE name = 'John'
name|age
--------
John|25
my_sqlite_cli> quit
$> 
```

To use the library:

MySqliteRequest: This class contains the methods for building a query.\ 
Each method returns an instance of MySqliteRequest to enable chaining.

from(table_name): This method sets the table to be queried.\
select(column_names): This method sets the columns to be selected.\
where(column_name, criterion): This method sets the condition for\
filtering rows.\
join(column_on_db_a, filename_db_b, column_on_db_b): This method\
joins two tables.\
order(order, column_name): This method orders the rows by a column.\
insert(table_name): This method sets the table to insert data into.\
values(data): This method sets the values to be inserted.\
update(table_name): This method sets the table to be updated.\
set(data): This method sets the values to update.\
delete: This method sets the condition for deleting rows.\
run: This method executes the query and returns the result as\
an array of hashes.

Test peer review cases by uncommenting the function calls in the cli file.

### The Core Team
Timak Timur\
Tizhe Paul


<span><i>Made at <a href='https://qwasar.io'>Qwasar SV -- Software Engineering School</a></i></span>
<span><img alt='Qwasar SV -- Software Engineering School's Logo' src='https://storage.googleapis.com/qwasar-public/qwasar-logo_50x50.png' width='20px'></span>

