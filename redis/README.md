# Redis

## Resources
- Redis official web: [https://redis.io/](https://redis.io/)
- Redis API reference: [https://redis.io/commands](https://redis.io/commands)

## Before we start

Clone the repository into a directory of your choice.

```
$ git clone http://github.com/cygni/cygni-competence-7-databases
```
Pull the official docker image for redis
```
$ docker pull redis
```

Start redis and connect with redis cli

```
$ docker run -v $pwd/redis:/usr/local/etc/redis --name cygni-redis -d redis redis-server /usr/local/etc/redis/redis.conf

$ docker run -it --link cygni-redis:redis --rm redis redis-cli -h redis -p 6379

redis:6379> PING

"PONG"
```

## Day 1 CRUD

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
Create a hash for the information of a specific user in your system. A user has a name, an email and a rating.
 - Create one user where you specify each data point within its own query in a transaction. (HSET)
 - Create another user without the transaction and specify all data points within one query. (HMSET)
 - Read a specific key within one of your maps (HGET)
 - Read out the full contents within one of your maps (HGETALL)
 
### Sets
- Create two sets with some arbitrary names make sure that atleast one name is present within both sets. (SADD)
- Try to add an already existing name to one of the sets. (SADD)
- Remove a name or two (SDEL)
- Read the contents of your sets (SMEMBERS)

#### Set operators
Try out:
- Union (SUNION)
- Storing the union of the sets (SUNIONSTORE)
- Difference (SDIFF)
- Storing the difference of the sets (SDIFFSTORE)

# Day 2 Pub/Sub and Configuration

## Pub Sub

## Configuration

use redis-benchmark to test your updates

docker exec -it cygni-redis redis-benchmark

stuff to play around with.
- save
- slave

### First way, update config file
 - docker restart cygni-redis
 
### Second way, CONFIGSET CONFIGREWRITE

 - CONFIG SET SAVE "900 1 300 10".
 - CONFIG REWRITE
 
# MOAR STUFFS, LUA scripting




