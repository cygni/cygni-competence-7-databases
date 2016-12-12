#NEO4J
-We'll use neo4j:3.0 in these exercises

##Resources
- Neo4j API reference: [https://neo4j.com/docs/developer-manual/current/](https://neo4j.com/docs/developer-manual/current/)
- Intro to cypher: [https://neo4j.com/developer/cypher-query-language/](https://neo4j.com/developer/cypher-query-language/)

##Before we start
###Things to prepare:
Clone or update git repository to directory of choice
```
$ git clone http://github.com/cygni/cygni-competence-7-databases 
cd cygni-competence-7-databases/
$ git pull --rebase
cd neo4j
```
Pull neo4j image:

```
-install docker (if you don't already have it) or make sure docker is up to date
$ docker pull neo4j:3.0
$ docker run \
     --publish=7474:7474 --publish=7687:7687 \
     --volume=$HOME/neo4j/data:/data \
     --net neo4j \
     neo4j:3.0
```
Then go to:
[http://localhost:7474/browser/](http://localhost:7474/browser/)

default login to neo4j is neo4j:neo4j, enter this then change password to abc123 (you can of course use something else here but then you have to remember this for curl examples!) 
You are all set!


###Before reading the chapter:
A lot of things has happened since the book was written:
The localhost:7474/webadmin is no longer apart of neo4j instead we are going to be working from localhost:7474/browser
Cypher is the preferred language for neo4j, it is made specifically for graphs and is less complex than gremlin.
Therefore we are still going to use most of the books examples but I have rewritten them using Cypher.


##First exercises:
In the first exercises we are going to be working from the browser view provided by neo4j. 
So go to: [http://localhost:7474/browser/](http://localhost:7474/browser/)
We are going to create a graph consisting of a Winery, three wines, a Wine Magasine, three people and 
some more stuff that all have different relations to each other.


1. Create a Wine node, with [name: Prancing Wolf Ice Wine 2007]
```
 CREATE (w:Wine {name: 'Prancing Wolf Ice Wine 2007'})
```

2. Create a Magazine with [name: 'Wine Expert Monthly']
```
 CREATE (m:Magazine {name: 'Wine Expert Monthly'})
```

3. Create a relationship of reported_on from magasine to wine  
```
match (w:Wine {name: 'Prancing Wolf Ice Wine 2007'}), 
match (m:Magazine {name: 'Wine Expert Monthly'})
create (m)-[:REPORTED_ON]->(w)
```

4. A relationship can have properties as well so lets add rating to the reported_on relationship
```
match ()-[r:REPORTED_ON]->() set r.rating = 92 return r
```

since we only have one relationship of type reported_on, we do not have to be specific on which one

5. Add a the grape type reisling,  Prancing Wolf Ice Wine is a reisling so lets add a relationship between them a the same time of type grape_type and style ice_wine
```
match (w:Wine {name: 'Prancing Wolf Ice Wine 2007'})
create(g:Grape {name: 'Reisling'})<-[:GRAPE_TYPE {style: 'ice_wine'}]-(w)
```

6. Let look at our present graph 
_To view everything in graph_
```
match (n) return n
```

7. To get all relationships in a graph 
```
match ()-[r]-() return r
```

8. Get a specific node by built-in id using cypher method ID(<node>)
```
Match (n) where ID(n) = <id> return n
```

9. Get properties for a specific node
```
Match (n) where ID(n) = 0 return properties(n)
```

10. Filter graph on specific value
```
Match (n {name: 'Reisling'}) return n
```

11. Get relations from all specific node 
  * Get all relations from a node
```
MATCH (:Grape {name: 'Reisling'})-[r]-() 
RETURN r 
```
  * Get all incoming relations from a node
```
MATCH (:Grape {name: 'Reisling'})<-[r]-() 
RETURN r
```
  * Get all outgoing relations from a node
```
MATCH (:Grape {name: 'Reisling'})-[r]->() 
RETURN r
```

12.Get the name of the nodes that a relationship point to
```
MATCH (:Magazine {name: 'Wine Expert Monthly'})-[r:REPORTED_ON]->(w) 
RETURN w.name
```

13.Create node winery with a relation 'produced' to wine
```
match (wine:Wine)
create (winery:Winery {name: 'Prancing Wolf Winery'})-[:PRODUCED]->(wine)
```
 
14.Create two more wines produced by Prancing wolf, of type reisling with styles
```
match (winery:Winery)
match (grape:Grape {name: 'Reisling'})
create(winery)-[:PRODUCED]->(w1:Wine {name:'Prancing Wolf Kabinett 2002'})
create(winery)-[:PRODUCED]->(w2:Wine {name:'Prancing Wolf Spatlese 2007'})
create(w1)-[:GRAPE_TYPE {style: 'kabinett'}]->(grape)
create(w2)-[:GRAPE_TYPE {style: 'spatlese'}]->(grape)
```

15.Add three people with relationships and wine preferences
 * Add Alice
```
create (alice:Person {name: 'Alice'})
with alice
match (wine:Wine {name: 'Prancing Wolf Ice Wine 2007'})
create (alice)-[r:LIKES]->(wine)
```

 * Add Tom
```
create (tom:Person {name: 'Tom'})
with tom
match (wine1:Wine {name: 'Prancing Wolf Ice Wine 2007'})
match (wine2:Wine {name: 'Prancing Wolf Kabinett 2002'})
create (tom)-[:LIKES]->(wine1)
create (tom)-[:LIKES]->(wine2)
with tom
match (m:Magazine)
create (tom)-[:TRUSTS]->(m)
```

 * Add Patty
```
create (patty:Person {name: 'Patty'})
with patty
match (tom:Person {name: 'Tom'})
match (alice:Person {name: 'Alice'})
create (tom)<-[:FRIENDS]-(patty)-[:FRIENDS]->(alice)
```

16.Find all of Alices friends
```
match (alice:Person {name: 'Alice'})-[:FRIENDS]-(w)
return w
```

17.Find everybody that are friends starting with Alice ...
```
match (alice:Person {name: 'Alice'})-[:FRIENDS*0..]-(w)
return w
```

 * Find all of Alice friends and friend of friends
```
match (p:Person {name: 'Alice'})-[:FRIENDS*1..]-(f) 
where not f.name = 'Alice'
return  f
```

 * Find Alices friends of friends
```
match (alice:Person {name: 'Alice'})-[:FRIENDS*1..2]-(w)
return w
```

18.Count how many times each name occurs in graph
```
match (n) 
with count(n.name) as groupCount,n 
return groupCount, n.name
```

19.Count likes 
```
match (n)-[:LIKES]->(w) 
with count(n.name) as groupCount,n, collect(w.name) as wineName
return groupCount, n.name, wineName
```

20.Wines not reported on
```
match (w:Wine)
where not (w)<-[:REPORTED_ON]-(:Magazine)
return count(w), collect(w.name)
```

21.match friends
```
match (w:Person)-[:FRIENDS]->(p:Person) 
with [w.name, p.name] AS common 
return common
```

22.match people with wines
```
match (p:Person)
optional match (p)-[:LIKES]-(w:Wine)
with [p.name, collect(w.name)] AS common return common
```
###CRUD
23.Add/Update property
```
match (p:Person {name: 'Alice'})-[l:LIKES]->() 
set l.weight = 95
return l
```

24.Remove property
```
match (p:Person {name: 'Alice'})-[l:LIKES]->() 
set l.weight = null
return l
```

Exercise time:





Day 2:

Using Neo4j with cUrl:


1. check if it is running
```
curl -u neo4j:abc123 http://localhost:7474/db/data/
```

2. Create a node with curl
```
curl -u neo4j:abc123 -i -X POST http://localhost:7474/db/data/node \
-H "Content-Type: application/json" \
-d '{"name": "P.G. WodeHouse", "genre": "Brittish humour"}'
```
returns a json with different paths for created node
 
3.
```
curl -u neo4j:abc123 -i -X POST http://localhost:7474/db/data/node \
-H "Content-Type: application/json" \
-d '{"name": "Jeeves Takes Charge", "style": "short story"}'
```
4.
```
curl -u neo4j:abc123 -i -X POST http://localhost:7474/db/data/node/371/relationships \
-H "Content-Type: application/json" \
-d '{"to": "http://localhost:7474/db/data/node/372", "type": "WROTE", "data" : {"published" : "November 28,1916"}}'
```
5. 
```
curl -u neo4j:abc123 -i -X POST http://localhost:7474/db/data/node/371/paths \
-H "Content-Type: application/json" \
-d '{"to": "http://localhost:7474/db/data/node/372", "type": "WROTE", "algorithm" : "shortestPath"}'
```
//Other algoritms djikstra, allPath, allSimplePaths

6. Data cleanup and load movie graph
```
Open localhost:7474/browser
match (n) detach delete n
example graphs
movie graph
follow instructions
 ```
7.Four degrees of Kevin Bacon
```
MATCH (bacon:Person {name:"Kevin Bacon"})-[*1..4]-(hollywood)
RETURN DISTINCT hollywood
```
8. Shortest path Kevin Bacon - Meg Ryan
```
MATCH p=shortestPath(
     (bacon:Person {name:"Kevin Bacon"})-[*]-(meg:Person {name:"Meg Ryan"})
   )
RETURN p
```
9. Random data
```
MATCH (a)-[:ACTED_IN]->(t) 
with  rand() as r, a
where r<0.1
RETURN a, r
ORDER BY r
```

Exercise time:
