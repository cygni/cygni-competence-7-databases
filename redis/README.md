# Redis

## Resources
- Redis official web: [https://redis.io/](https://redis.io/)
- Redis API reference: [https://redis.io/commands](https://redis.io/commands)

## Before we start

Clone the repository into a directory of your choice.

```bash
git clone http://github.com/cygni/cygni-competence-7-databases
```
Pull the official docker image for redis
```bash
docker pull redis
```

Start redis and connect with redis cli

```bash
docker network create -d bridge cygni-redis

cd REPOSITORY_PATH/redis

docker run -v $(pwd)/redis:/usr/local/etc/redis --name redis1 --net cygni-redis -d redis redis-server /usr/local/etc/redis/redis.conf

docker run -it --net cygni-redis --rm redis redis-cli -h redis1 -p 6379

redis:6379> PING

"PONG"
```

## Section 1 CRUD

First run this seeding script:

```bash
$ docker exec -it redis1 redis-cli eval "$(cat ./redis/crud.lua)" 0
```

you need to be within the redis folder of the repository.

lets inspect the keys we got from this seeding script.

Open up the shell where you had the redis-cli and run the command "KEYS *". Keys takes a pattern to match against and * is match all. (more info at [https://redis.io/commands/keys](https://redis.io/commands/keys))

You should now see a list of all the keys in our database.

Since a lot of the operators in redis are type specific we need to figure out the type of the keys we are interested in. To get the type of a key use the command "TYPE" (more info at [https://redis.io/commands/type](https://redis.io/commands/type)).

As you might have noticed the redis-cli has intellisense so it will suggest what you need to give a command for it to be able to execute.

```bash
& TYPE foo

> string


$ TYPE jon

> hash


& TYPE jon:compentences

> set
```

Lets start doing stuff.

### Create:

#### Permanent

Create an entry with the key count with a value of 1

#### Temporary (Expiry)

Create an entry with the key tempcount with a value of 1 and an expiry time of 2 mins

### Read:

Read both the count and the tempcount.
Wait until the tempcount has expired and try to read it again.

### Update:

Increase the count by 1 and then read it out

### Delete:

Delete count

## Transactions

1. In a transaction
 - Create a key with a suitable name and give it an integer value
 - Copy that value over to a new key.
 - Increment the first value
 - Read out both keys
 - Execute the transaction.

2. Do the same thing again but before you fire off the transaction discard it and verify that nothing was added to the database.

3. Do the same thing yet again but give the first key a string value. Still try to increment that value. Verify that we have now have two keys with the same string value. (There is no rollback within a transaction)

## Hashes and Sets

### Hashes

Since the key jon was a hash we can get all the keys for the data points we have about Jon with the help of "HKEYS". As we can see we have a name and a speciality.

Your assignment for hashes is to add two new people to our data set. Yourself and your favorite colleague. For one please use "HSET" and for the other "HMSET".

Inspect your result with "HKEYS", "HGET" and "HGETALL"


### Sets

There was one key within our initial set that was a set. To inspect this set with the help of "SMEMBERS".

Your inital assignment for sets is to complete the hashes you created earlier with two sets of competences so we have the same type of data for everyone. Look at SADD, SDEL.

After that answer these questions with the help of the set operators listed below.

 - How many competences do you all have in total?
 - Is there any competences that you have that Jon lack?
 - Is there any competences that Jon has that you lack?
 - Is there any competences that you all share?


#### Set operators

- SUNION, returns the union of two or more sets
- SUNIONSTORE, calculates the union of two or more sets and stores that at a specific key
- SDIFF, returns the difference of two or more sets
- SDIFFSTORE, calculates the difference of two or more sets and stores that at a specific key
- SINTER, returns the intersection of two or more sets
- SINTERSTORE, calculates the intersection of two or more sets and stores that at a specific key
- SRANDMEMBER, returns a random member from a set
- SCARD, calculates the cardinality (length) of a set



# Section 2 Configuration


## Configuration

we need to add another redis container to test replication

```bash
docker run -v $(pwd)/redis:/usr/local/etc/redis --name redis2 --net cygni-redis -d redis redis-server

docker run -it --net cygni-redis --rm redis redis-cli -h redis2 -p 6379
```

### Updating Redis Configuration

##### Testing

use redis-benchmark to test your updates

```bash
docker exec -it cygni-redis redis-benchmark
```

There are two ways of updating the Redis configuration.

#### First way, update config file

Within the repository within the redis folder there is a file named redis.conf.
That is the config file used for the first redis instance that we deployed to a container.

How we created that container:
```bash
docker run -v <pre><b>$(pwd)/redis:/usr/local/etc/redis</b></pre> --name redis1 --net cygni-redis -d redis redis-server <pre><b>/usr/local/etc/redis/redis.conf</b></pre>
```

```bash
docker restart cygni-redis
```

#### Second way, CONFIGSET CONFIGREWRITE

 - CONFIG SET SAVE "900 1 300 10".
 - CONFIG REWRITE

### Persistence

### Replication

### Authentication


# Section 3 Pub/Sub



# Section 4 LUA scripting

## EVAL

takes a lua script as a string, a number of string arguments, and a list of those arguments.
All arguments are stored within the KEYS array and lua is 1 indexed. So the first argument is located at KEYS[1].

redis:6379> EVAL "return redis.call('set',KEYS[1],'bar')" 1 foo

## Pass script file to EVAL

 - Navigate into the redis folder in the repository
 - Open said file
 - Modify stuff
 - run: docker exec -it cygni-redis redis-cli eval $(cat ./redislua.lua) 1 foo
