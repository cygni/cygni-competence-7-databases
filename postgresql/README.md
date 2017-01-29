#Postgres

##Postgres documentation

https://www.postgresql.org/docs/9.6/static/index.html

##Preparations

1) Install docker

    Mac: https://docs.docker.com/docker-for-mac/
    
    Linux: https://docs.docker.com/engine/installation/linux/
    
    Windows: https://docs.docker.com/docker-for-windows/

2) Pull down the postgres image
        
        docker pull postgres
        
3) Startup a container `cygni` based on the image we downloaded

        docker run --publish=5432:5432 --name cygni -e POSTGRES_PASSWORD=cygni -d postgres
         
4) Connect to the database using a psql prompt (password: cygni)
         
        docker run -it --rm --link cygni:postgres postgres psql -h postgres -U postgres

5) Create the database `book`

        CREATE DATABASE book;
        
6) Connect to `book`
        
        \c book

7) Create the table `countries`
        
        CREATE TABLE countries (
        country_code char(2) PRIMARY KEY,
        country_name text UNIQUE
        );
        
8) List relations
        
        \d
        
    output:
    
                   List of relations
         Schema |   Name    | Type  |  Owner   
        --------+-----------+-------+----------
         public | countries | table | postgres
        (1 row)

9) Quit the prompt (and disconnect from the db)

        \q
        
10) (Optional) Install a gui-client (i.e dbvisualizer or simply use intellij 'database')
    https://www.dbvis.com/
  
    So by now, anytime you want to connect to your `book` database, use the gui app of your choice or step 4 above.
    

## Preparations - end   
       
## Day 1 - CRUD operations (together)

![alt text](https://github.com/cygni/cygni-competence-7-databases/blob/master/postgresql/day1_relations.png "Day 1 table relations")

1)  Insert rows to table `countries`.

        INSERT INTO countries (country_code, country_name)
        VALUES
        ('us', 'United States'),
        ('mx', 'Mexico'),
        ('au', 'Australia'),
        ('gb', 'United Kingdom'),
        ('de', 'Germany'),
        ('ll', 'Loompaland');

2) Delete 'Loompaland' from `countries`.

        DELETE FROM countries
        WHERE country_code = 'll';
        
3) List all data from `countries`.

        SELECT * FROM countries;
        
    output:
    
         country_code |  country_name  
        --------------+----------------
         us           | United States
         mx           | Mexico
         au           | Australia
         gb           | United Kingdom
         de           | Germany
        (5 rows)

        
4) Create the table `cities` and insert a row.
        
        CREATE TABLE cities (
          name         TEXT NOT NULL,
          postal_code  VARCHAR(9) CHECK (postal_code <> ''),
          country_code CHAR(2) REFERENCES countries,
          PRIMARY KEY (country_code, postal_code)
        );
        
        INSERT INTO cities
        VALUES ('Portland', '887200', 'us');
        
5) Update postal code of Portland.
       
       UPDATE cities
       SET postal_code = '97205'
       WHERE name = 'Portland';
       
6) Combine output from two tables using joins.

        SELECT
          cities.*,
          country_name
        FROM cities
          INNER JOIN countries ON cities.country_code = countries.country_code;
          
    output:
      
             name   | postal_code | country_code | country_name  
          ----------+-------------+--------------+---------------
           Portland | 97205       | us           | United States
          (1 row)


7) Create and insert rows to `venues`.

        CREATE TABLE venues (
          venue_id       SERIAL PRIMARY KEY,
          name           VARCHAR(255),
          street_address TEXT,
          type           CHAR(7) CHECK (type IN ('public', 'private')) DEFAULT 'public',
          postal_code    VARCHAR(9),
          country_code   CHAR(2),
          FOREIGN KEY (country_code, postal_code) REFERENCES cities (country_code, postal_code) MATCH FULL
        );
        
        INSERT INTO venues (name, postal_code, country_code)
        VALUES ('Crystal Ballroom', '97205', 'us');
        

        INSERT INTO venues (name, postal_code, country_code)
        VALUES ('Voodoo Donuts', '97205', 'us')
        RETURNING venue_id;
        
8) Combine output from two tables using a compound join.

        SELECT
          v.venue_id,
          v.name,
          c.name
        FROM venues v
          INNER JOIN cities c ON v.postal_code = c.postal_code AND v.country_code = c.country_code;
        
    output:
    
         venue_id |       name       |   name   
        ----------+------------------+----------
                2 | Voodoo Donuts    | Portland
                1 | Crystal Ballroom | Portland
        (2 rows)

        
9) Create an `events` table with some rows
        
        CREATE TABLE events (
          event_id SERIAL PRIMARY KEY,
          title    VARCHAR(255),
          starts   TIMESTAMP,
          ends     TIMESTAMP,
          venue_id INT,
          FOREIGN KEY (venue_id) REFERENCES venues (venue_id)
        );
        
        INSERT INTO events (title, starts, ends, venue_id)
        VALUES
          ('LARP Club', '2012-02-15 17:30:00', '2012-02-15 19:30:00', 2),
          ('April Fools Day', '2012-04-01 00:00:00', '2012-04-01 23:59:00', NULL),
          ('Christmas Day', '2012-12-25 00:00:00', '2012-12-25 23:59:00', NULL);

10) Inner joins vs. outer joins

    inner join:
    
        SELECT
          e.title,
          v.name
        FROM events e
          INNER JOIN venues v ON e.venue_id = v.venue_id;

    output:
          
        title   |     name
        -----------+---------------
        LARP Club | Voodoo Donuts
        (1 row)
         
     outer join:
         
        SELECT
          e.title,
          v.name
        FROM events e
          LEFT OUTER JOIN venues v ON e.venue_id = v.venue_id;
    
    output:      
          
              title      |     name      
        -----------------+---------------
         LARP Club       | Voodoo Donuts
         April Fools Day | 
         Christmas Day   | 
        (3 rows)

## Day 1 - exercises

1)  Write a query to select all tables we have created.
(Hint: Check the postgres documentation for the table 'pg_class')

2) Write a query that finds the country name of the LARP Club event.

3) Alter the `venues` table to contain a boolean column called `active`, with the default value of TRUE.

## Day 2 - Advanced queries, functions etc.

1) Insert a few more rows, notice the sub-selects to get the venue_id

        INSERT INTO countries (country_code, country_name) VALUES ('se', 'Sweden');
        
        INSERT INTO cities (name, postal_code, country_code)
        VALUES
          ('Stockholm', '111 44', 'se'),
          ('Göteborg', '411 08', 'se');
        
        INSERT INTO venues (name, street_address, postal_code, country_code)
        VALUES
          ('Cygni AB', 'Jakobsbergsgatan 22', '111 44', 'se'),
          ('Cygni Väst AB', 'St. Nygatan 31', '411 08', 'se');
        
        INSERT INTO events (title, starts, ends, venue_id)
        VALUES
          ('Kompetensutveckling postgres, Stockholm', '2017-02-15 17:30:00', '2017-02-15 20:00:00', (SELECT venue_id
                                                                                                     FROM venues
                                                                                                     WHERE name = 'Cygni AB')),
          ('Kompetensutveckling postgres, Göteborg', '2017-02-21 17:30:00', '2017-02-21 20:00:00', (SELECT venue_id
                                                                                                    FROM venues
                                                                                                    WHERE
                                                                                                      name = 'Cygni Väst AB'));

2) Select the number of events matching 'Kompetensutveckling postgres' using the aggregate function `count`.

Expected output:

            count 
            -------
                 2
            (1 row)
            
            
3) Write a query to show the number of events per year (`extract` and `GROUP BY`).
            
Expected output:
            
             year | events 
            ------+--------
             2017 |      2
             2012 |      3
            (2 rows)

4) Display the number of events located in each country (`GROUP BY`).

Expected output:

              country_name  | count 
            ----------------+-------
             Germany        |     0
             Mexico         |     0
             Australia      |     0
             United States  |     1
             Sweden         |     2
             United Kingdom |     0
            (6 rows)


5) Modify your previous query to only display country names where there are events, using the keyword `HAVING`.

Expected output:

             country_name  | count 
            ---------------+-------
             United States |     1
             Sweden        |     2
            (2 rows)

           
6) A very simple function (stored procedure) is written in the following way:
         
         
            CREATE [OR REPLACE] FUNCTION function_name (arguments) 
            RETURNS return_datatype AS $variable_name$
              DECLARE
                declaration;
                [...]
              BEGIN
                < function_body >
                [...]
                RETURN { variable_name | value }
              END; LANGUAGE plpgsql;

Create a function `numberOfEvents` which returns the count of all rows in the table `events`.

            select numberOfEvents();
            
             numberofevents 
            ----------------
                          5
            (1 row)

7) Postgres allows overloading! Create a new function with the same name `numberOfEvents`, that takes one argument `country_code`, 
so when calling it with `select numberOfEvents('se');` you should get the number of events located in that country. 

             numberofevents 
            ----------------
                          2
            (1 row)


## Day 3 - Indexes, extensions, json

Lets create a large table with some data to experiment with.
I´ve added a few different data types, such as integer, uuid, point, timestamp. 

In order for us to generate uuid's in postgres we need an extension!

Install that with: `CREATE EXTENSION "uuid-ossp";`


            CCREATE TABLE cygnus AS
               SELECT
                 generate_series(1, 20000)                           AS id,
                 uuid_generate_v1()                                  AS uuid,
                 point(ceil(random() * 1000), ceil(random() * 1000)) AS point,
                 random() * (TIMESTAMP '2017-02-21 20:00:00' - TIMESTAMP '2017-01-01 00:00:00') +
                 TIMESTAMP '2017-01-01 00:00:00'                     AS datetime;

            
Analyze the result from a query
            
            
            book=# explain analyze select * from cygnus order by id limit 20;
                                                                         QUERY PLAN                                                             
            ------------------------------------------------------------------------------------------------------------------------------------
             Limit  (cost=459554.62..459554.67 rows=20 width=44) (actual time=58204.630..58204.775 rows=20 loops=1)
               ->  Sort  (cost=459554.62..484554.64 rows=10000006 width=44) (actual time=58204.622..58204.671 rows=20 loops=1)
                     Sort Key: id
                     Sort Method: top-N heapsort  Memory: 26kB
                     ->  Seq Scan on cygnus  (cost=0.00..193458.06 rows=10000006 width=44) (actual time=0.031..29437.617 rows=10000000 loops=1)
             Planning time: 0.108 ms
             Execution time: 58204.901 ms
            (7 rows)
            
            
Create an index on the column id
            
            book=# create index idx_cygnus_id on cygnus(id);
            CREATE INDEX
            
            book=# \d cygnus
                           Table "public.cygnus"
              Column  |            Type             | Modifiers 
            ----------+-----------------------------+-----------
             id       | integer                     | 
             uuid     | uuid                        | 
             point    | point                       | 
             datetime | timestamp without time zone | 
            Indexes:
                "idx_cygnus_id" btree (id)
            
Analyze the result again            
                        
            book=# explain analyze select * from cygnus order by id limit 20;
                                                                            QUERY PLAN                                                                
            ------------------------------------------------------------------------------------------------------------------------------------------
             Limit  (cost=0.43..1.14 rows=20 width=44) (actual time=0.040..0.238 rows=20 loops=1)
               ->  Index Scan using idx_cygnus_id on cygnus  (cost=0.43..353149.43 rows=10000000 width=44) (actual time=0.033..0.100 rows=20 loops=1)
             Planning time: 1.033 ms
             Execution time: 0.339 ms
            (4 rows)
            
            book=# 
            
1) Play around with the table `cygnus` and see which scan method postgres uses for diffent queries, and how that changes when applying an index of your choice.            
            
2) Configure postgres to use the extension `cube`

3) Run `code/create_movies.sql` and `code/movies_data.sql` 
   (hint: -v /Library/Projects/cygni-competence-7-databases/postgresql/code/:/tmp/code)

4) Create a new table `movies_json` with the following structure, where the field `json` contains a json represention 
   of the table structure above.

Table structure:

            book=# \d movies_json
             Table "public.movies_json"
             Column | Type  | Modifiers 
            --------+-------+-----------
             id     | uuid  | 
             json   | jsonb |
              
              
Where the data looks something like this:
              
            {
              "title": "Star Wars",
              "actors": [
                {
                  "name": "Mark Hamill",
                  "actor_id": 3165
                },
                {
                  "name": "Carrie Fisher",
                  "actor_id": 644
                },
                {
                  "name": "Harrison Ford",
                  "actor_id": 1753
                },
                {
                  "name": "Peter Cushing",
                  "actor_id": 3768
                }
              ],
              "genres": [
                {
                  "name": "Adventure",
                  "score": 7
                },
                {
                  "name": "Fantasy",
                  "score": 7
                },
                {
                  "name": "SciFi",
                  "score": 10
                }
              ],
              "movie_id": 1
            }  
            
5) Try querying the data using json specific functions (check the doc)     
       
6) Using explain or explain analyze, see how postgres fetches the data
       
7) Apply an index to your json data and see if and how it changes with the query you ran.       
            
            
            
            



