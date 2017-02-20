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

3) Build our own image `postgres-client` with the code samples and javascript support pre-installed

        cd build-client
        docker build -t postgres-client .

4) Startup a container `cygni_db` based on the image we downloaded

        docker run --publish=5432:5432 --name cygni_db -e POSTGRES_PASSWORD=cygni -d postgres-client

5) Connect to the database using a psql prompt (password: cygni)

        docker run -it --rm --link cygni_db:postgres postgres-client psql -h postgres -U postgres

6) Create the database `book`

        CREATE DATABASE book;

7) Connect to `book`

        \c book

    Output:

        postgres=# \c book
        You are now connected to database "book" as user "postgres".


8) Quit the prompt (and disconnect from the db)

        \q

9) (Optional) Install a gui-client (i.e dbvisualizer or simply use intellij 'database')
    https://www.dbvis.com/

    So by now, anytime you want to connect to your `book` database, use the gui app of your choice or step 5 above.


## Preparations - end   

## Day 1 - CRUD operations (together)

![alt text](https://github.com/cygni/cygni-competence-7-databases/blob/master/postgresql/events_diagram.png "Day 1 table relations")

1)  Create the table `countries` and insert rows.

        CREATE TABLE countries (
        country_code char(2) PRIMARY KEY,
        country_name text UNIQUE
        );

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

2) Select the number of events that contains 'Kompetensutveckling postgres' using the aggregate function `count`.

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

8) (Optional) Create the function `numberOfEvents_<language>` using your preferred coding langauge that is available as an extension to postgres.
The image built from `build/Dockerfile` has javascript capabilities pre-installed
(https://github.com/plv8/plv8)

So if you want to keep this simple, choose to write one with javascript :-)
Don't forget to load it with: `CREATE EXTENSION plv8;`



## Day 3 - Indexes, extensions, json

During the first couple of exercises we will import the movies/actors structure and write queries that involves using the extension `cube`

1)  Configure postgres to use the extension `cube`. 
    Run `/code/create_movies.sql` and `/code/movies_data.sql` 
   (hint: if using postgres-client docker image the sql files are in /code)
   
![alt text](https://github.com/cygni/cygni-competence-7-databases/blob/master/postgresql/movies_diagram.png "Movies")   

2) Select all action movies from the imported structure

                             title                     
        -----------------------------------------------
         Apocalypse Now
         Blade Runner
         Raiders of the Lost Ark
         Indiana Jones and the Temple of Doom
         Indiana Jones and the Last Crusade
         Beverly Hills Cop
         ...

3) Select all comedy movies where arnold is an actor

               title        
        --------------------
         True Lies
         The Running Man
         Kindergarten Cop
         Stay Hungry
         Junior
         Jingle All the Way
         Twins
         Commando
         
4) Find all movies that are categorized as `Action` and `SciFi`
       
                          title                   
       -------------------------------------------
        Aliens
        Alive
        Bad Blood
        Barbarella
        Blade Runner
        Cyborg
        ...

5) Find the top 5 best ranked movies (average of all scores in different categories)


                  title          | score 
        -------------------------+-------
         The Island              |    12
         The Blair Witch Project |  11.5
         Mars Attacks!           |    11
         Cruel Intentions        |    11
         Edward Scissorhands     |    11


6) (Optional) Now when you are familiarized with the structure and how to query the movies-structure using `cube` etc, we have an optional task to play around with json. 
Create a new table `movies_json` with the following structure, where the field `json` contains a json represention
of the table structure above.
If you want to jump directly into querying with json, copy and paste the code from `answers\3_6_movies_json.sql`

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

7) Query the new structure to find the movie with movie_id = 1
    
            title    
        -------------
         "Star Wars"
        (1 row)

8) Find movies where Tom Hanks is an actor in the json structure above.

                   title            
        -----------------------------
         Forrest Gump
         The Green Mile
         Apollo 13
         Saving Private Ryan
         Sleepless in Seattle
         Toy Story
         Toy Story 2
         ...

9) Lets create a large table with some data to experiment with.
I´ve added a few different data types, such as integer, uuid, point, timestamp.

In order for us to generate uuid's in postgres we need an extension!

Install that with: `CREATE EXTENSION "uuid-ossp";`


            CREATE TABLE cygnus AS
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

10) Play around with the table `cygnus` and see which scan method postgres uses for diffent queries, and how that changes when applying an index of your choice.
            
            

