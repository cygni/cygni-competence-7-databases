#Postgres

[intellij]: ./intellij_setup.png "Intellij setup"

[dbvisualizer]: ./dbvisualizer_setup.png "DbVisualizer setup"

##Postgres documentation

Postgres doc: https://www.postgresql.org/docs/9.6/static/index.html

##Preparations

1) Install docker

    Mac: https://docs.docker.com/docker-for-mac/
    
    Linux: https://docs.docker.com/engine/installation/linux/
    
    Windows: https://docs.docker.com/docker-for-windows/

2) Pull down the postgres image
        
        docker pull postgres
        
3) Create a postgres / cygni container

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
        
                   List of relations
         Schema |   Name    | Type  |  Owner   
        --------+-----------+-------+----------
         public | countries | table | postgres
        (1 row)

9) Quit the prompt (and disconnect from the db)

        \q
        
10) (Optional) Install a gui-client (i.e dbvisualizer or simply use intellij 'database')
  
    https://www.dbvis.com/
    
    So by now, anytime you want to connect to your `book` database, use the gui app of your choice or 4) above.
      
    ![alt text][intellij]
    
    ![alt text][dbvisualizer]
