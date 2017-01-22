# Redis

## Resources
- Redis official web: [https://redis.io/](https://redis.io/)
- Redis API reference: [https://redis.io/commands](https://redis.io/commands)
- Slide show: [google-drive](https://docs.google.com/presentation/d/12xN7uAy_w6xU-Iw2nM_zaAFsijIn966cgg80KTPLDes/edit?usp=sharing)

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

By the way. Commands in Redis are not case sensitive but I've used that for the sake of clarity.

## Section 1 CRUD

First run this seeding script:

```bash
docker exec -it redis1 redis-cli eval "$(cat ./redis/crud.lua)" 0
```

you need to be within the redis folder of the repository.

lets inspect the keys we got from this seeding script.

Open up the shell where you had the redis-cli and run the command "KEYS *". Keys takes a pattern to match against and * is match all. (more info at [https://redis.io/commands/keys](https://redis.io/commands/keys))

You should now see a list of all the keys in our database.

```bash
redis1:> KEYS *
1) "jon"
2) "jon:competences"
3) "users"
4) "foo"
```

Since a lot of the operators in redis are type specific we need to figure out the type of the keys we are interested in. To get the type of a key use the command "TYPE" (more info at [https://redis.io/commands/type](https://redis.io/commands/type)).

As you might have noticed the redis-cli has intellisense so it will suggest what you need to give a command for it to be able to execute.

```bash
redis1:6379> TYPE foo
string

redis1:6379> TYPE users
string

redis1:6379> TYPE jon
hash

redis1:6379> TYPE jon:compentences
set
```

Lets start doing stuff.

### Strings

#### Read:

```bash
redis1:6379> GET foo
"bar"

redis1:6379> GET users
"1000"
```

#### Create:

##### Permanent

```bash
redis1:6379> SET name Emil
OK

redis1:6379> SET count 1
OK
```

##### Temporary (Expiry)

```bash
redis1:6379> SET tempname Emil EX 10
OK

redis1:6379> GET tempname
"Emil"

redis1:6379> GET tempname
(nil)

redis1:6379> SET tempname Emil PX 10000
OK

redis1:6379> GET tempname
"Emil"

redis1:6379> GET tempname
(nil)
```

#### Update:

```bash
redis1:6379> APPEND name " Bergstrom"
(integer) 14

redis1:6379> GET name
"Emil Bergstrom"

redis1:6379> INCR count
(integer) 2

redis1:6379> GET count
"2"
```

#### Delete:

```bash
redis1:6379> DEL name
(integer) 1

redis1:6379> DEL count foo
(integer) 2

redis1:6379> DEL doesnotexist
(integer) 0
```

### Transactions

```bash
redis1:6379> MULTI
OK

redis1:6379> SET name Emil
QUEUED

...
QUEUED

redis1:6379> EXEC
OK
```

With the help of everything above. Your assignment is to, within a transaction:
 - Create a counter
 - Increment that counter by 5 (INCR or INCRBY)
 - Read the counter.

Do the same thing again but before you fire off the transaction discard it and verify that the db didn't change. (DISCARD)


#### Error example

```bash
redis1:6379> MULTI
OK

redis1:6379> SET name Emil
QUEUED

redis1:6379> HGET name a
QUEUED

redis1:6379> SET lastname Bergstrom
QUEUED

redis1:6379> EXEC
1) OK
2) (error) WRONGTYPE Operation against a key holding the wrong kind of value
3) OK
```


### Hashes

Since the key jon was a hash we can get all the keys for the data points we have about Jon with the help of "HKEYS". As we can see we have a name and a specialty.

Your assignment for hashes is to add two new people to our data set. Yourself and your favorite colleague. For one please use "HSET" and for the other "HMSET".

Inspect your result with "HKEYS", "HGET" and "HGETALL"


### Sets

There was one key within our initial set that was a set. To inspect this set with the help of "SMEMBERS".

Your inital assignment for sets is to complete the hashes you created earlier with two sets of competences so we have the same type of data for everyone. Look at SADD, SREM.

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


## Section 2 Configuration

### Configuration

#### Updating Redis Configuration

##### Testing

There are two ways of updating the Redis configuration.

##### First way, update config file

Within the repository within the redis folder there is a file named redis.conf.
That is the config file used for the first redis instance that we deployed to a container.

How we created the  first container:
```bash
docker run -v $(pwd)/redis:/usr/local/etc/redis --name redis1 --net cygni-redis -d redis redis-server /usr/local/etc/redis/redis.conf
```

To update the config for that update the redis.conf and restart the container. I.e. change the timeout at line 79 in the config.

```bash
docker restart redis1
```

##### Second way, CONFIGSET CONFIGREWRITE

```bash
redis1:6379> CONFIG SET TIMEOUT "5000".
OK

redis1:6379> CONFIG REWRITE
OK
```

CONFIG SET requires a setting to alter and a string argument with the new options. This will be applied to the running database when executed.
To save the current configuration the CONFIG REWRITE command is used. This will update the currently used configuration file for redis.

#### Persistence

Use redis-benchmark to examine the differences between different persistance models.

First lets get a base line.

```bash
docker exec -it redis1 redis-benchmark > benchmarkbase.txt
```

Lets enable append-only. The append-only file is an alternative, fully-durable strategy for Redis. It became available in version 1.1.
From now on, every time Redis receives a command that changes the dataset it will append it to the AOF. When you restart Redis it will re-play the AOF to rebuild the state.

```bash
appendonly yes

# appendfsync always
appendfsync everysec
# appendfsync no
```

#### Replication

we need to add another redis container to test replication

```bash
docker run -v $(pwd)/redis:/usr/local/etc/redis --name redis2 --net cygni-redis -d redis redis-server

docker run -it --net cygni-redis --rm redis redis-cli -h redis2 -p 6379
```

One way to setup replication is through the CLI.

```bash
redis1:6379> SLAVEOF redis2 6379
OK

redis2:6379> SET name Jon
OK

redis1:6379> GET name
"Jon"

redis1:6379> SLAVEOF NO ONE
OK

redis2:6379> SET name Emil
OK

redis1:6379> GET name
"Jon"
```

The other way is through the config file. Your assignment is now to setup replication through the config file. Look at line 194 in the config file.

#### Security

##### Password

To setup basic password authentication against your redis instance the REQUIREPASS configuration option is used.
That one wants the password as a plain text string as a password.

```bash
redis1:6379> CONFIG SET REQUIREPASS "bestpassword"
OK

redis1:6379> SET foo bar
(error) NOAUTH Authentication required.

redis1:6379> AUTH bestpassword
OK

redis1:6379> SET foo bar
OK
```

Your assignment is to setup the password through the config file. Look at line 383 in the config file.

##### Command renaming

Done through the config file.
Look at line 398 in the configuration file.

```bash
rename-command SET NEWSET
```

Restart the docker instance with:

```bash
docker restart redis1
```

Command renaming does not allow duplicates. If duplicates are found the instance wont start.

## Section 3 Pub/Sub

Now we need to connect two CLIs to the same redis instance. Run the following command in two shells:

```bash
docker exec -it redis1 redis-cli
```

Your assignment is to, within one of the shells, subscribe to two channels with the help of the SUBSCRIBE command.
After that try to PUBLISH to either of the two channels within the other shell.

Remember that the CLI has auto-complete suggestions on what to supply to different commands.

&nbsp;
&nbsp;
&nbsp;
&nbsp;

Redis-cli1 (Subscriber):

```bash
redis1:6370> SUBSCRIBE foo bar
Reading messages... (press Ctrl-C to quit)
1) "subscribe"
2) "foo"
3) (integer) 1
1) "subscribe"
2) "bar"
3) (integer) 2

1) "message"
2) "foo"
3) "foo message"

1) "message"
2) "bar"
3) "bar message"
```

Redis-cli2 (Publisher):

```bash
redis:6379>PUBLISH foo "foo message"
(integer) 1

redis:6379>PUBLISH bar "bar message"
(integer) 1
```

One cool thing to note is that even the publishes are replicated to slaves so one can subscribe to the channel of a slave and receive the messages published to master.

## Section 4 LUA scripting

### EVAL

takes a lua script as a string, a number of string arguments, and a list of those arguments.
All arguments are stored within the KEYS array and lua is 1 indexed. So the first argument is located at KEYS[1].

```bash
redis1:6379> EVAL "return redis.call('set',KEYS[1],'bar')" 1 foo
```

### Pass script file to EVAL


```bash
docker exec -it redis1 redis-cli eval "$(cat ./redis/redislua.lua)" 1 foo
```
