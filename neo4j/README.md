#Cygni competence - 7 databases NEO4J

-We'll use neo4j:3.0 in these exercises

Todo before 12/10
-docker pull neo4j:3.0
-docker run \
     --publish=7474:7474 --publish=7687:7687 \
     --volume=$HOME/neo4j/data:/data \
     --net neo4j \
     neo4j:3.0
-curl --user neo4j:neo4j http://localhost:7474/db/data/ 
if curl returns data, you are all set!

The localhost:7474/webadmin is no longer apart of neo4j instead we are going to be working from localhost:7474/browser

We are going to skip all gremlin parts of the book instead I have rewritten the examples using Cypher.
Neo4js own preferred language is Cypher and there is no support for gremlin in neo4j 3.0.
So you can skip reading 221-238 and instead read the following:
We are going to be using the same examples as the book so first we are going to represent a winery with wines, a wine magasine, and a couple of friends.

Create a Wine node, with name Prancing Wolf Ice Wine 2007
1.CREATE (:Wine {name: 'Prancing Wolf Ice Wine 2007'})

Create a Magazine node with [name: 'Wine Expert Monthly']
2.CREATE (:Magazine {name: 'Wine Expert Monthly'})

Create a relationship between the wine and the magazine of type reported_on
3.
match (w:Wine {name: 'Prancing Wolf Ice Wine 2007'}), 
match (m:Magazine {name: 'Wine Expert Monthly'})
create (m)-[:REPORTED_ON]->(w)

curl --user neo4j:<password> http://localhost:7474/db/data/relationship/<id>


4.Relationship can have properties as well so lets add rating to the Reported_on relationship
match ()-[r:REPORTED_ON]->() set r.rating = 92 return r

5. Add a Grape node with name reisling, a relationship to Prancing Wolf Ice Wine with grape_type and style ice_wine
match (w:Wine {name: 'Prancing Wolf Ice Wine 2007'})
create(g:Grape {name: 'Reisling'})<-[:GRAPE_TYPE {style: 'ice_wine'}]-(w)

6. get all nodes in a tree
match (n) return n

7. Get all relationships 
match ()-[r]-() return r

8. Get specific node by id
Match (n) where ID(n) = <id> return n

9.Get properties for node
Match (n) where ID(n) = 0 return properties(n)

10.Filter on specific value
Match (n {name: 'Reisling'}) return n

11.Get relations from a node
MATCH (:Grape {name: 'Reisling'})-[r]-() 
RETURN r -> Get all relations from a node

MATCH (:Grape {name: 'Reisling'})<-[r]-() 
RETURN r -> Get all incoming relations from a node

MATCH (:Grape {name: 'Reisling'})-[r]->() 
RETURN r -> Get all outgoing relations from a node

12.Get nodes that relationship point to
MATCH (:Magazine {name: 'Wine Expert Monthly'})-[r:REPORTED_ON]->(w) 
RETURN w.name

13.Create node winery with a relation 'produced' to wine
match (wine:Wine)
create (winery:Winery {name: 'Prancing Wolf Winery'})-[:PRODUCED]->(wine)
 
14. Create two more wines produced by Prancing wolf, of grape type reisling with styles
match (winery:Winery)
match (grape:Grape {name: 'Reisling'})
create(winery)-[:PRODUCED]->(w1:Wine {name:'Prancing Wolf Kabinett 2002'})
create(winery)-[:PRODUCED]->(w2:Wine {name:'Prancing Wolf Spatlese 2007'})
create(w1)-[:GRAPE_TYPE {style: 'kabinett'}]->(grape)
create(w2)-[:GRAPE_TYPE {style: 'spatlese'}]->(grape)

15. Adding three people with relationships and wine preferences
//Add Alice
create (alice:Person {name: 'Alice'})
with alice
match (wine:Wine {name: 'Prancing Wolf Ice Wine 2007'})
create (alice)-[r:LIKES]->(wine)

//Add Tom
create (tom:Person {name: 'Tom'})
with tom
match (wine1:Wine {name: 'Prancing Wolf Ice Wine 2007'})
match (wine2:Wine {name: 'Prancing Wolf Kabinett 2002'})
create (tom)-[:LIKES]->(wine1)
create (tom)-[:LIKES]->(wine2)
with tom
match (m:Magazine)
create (tom)-[:TRUSTS]->(m)

//Add Patty
create (patty:Person {name: 'Patty'})
with patty
match (tom:Person {name: 'Tom'})
match (alice:Person {name: 'Alice'})
create (tom)<-[:FRIENDS]-(patty)-[:FRIENDS]->(alice)

16.Find all of Alices friends
match (alice:Person {name: 'Alice'})-[:FRIENDS]-(w)
return w

17.Find Alice and all of her friends, and their friends ...
match (alice:Person {name: 'Alice'})-[:FRIENDS*0..]-(w)
return w

//Find all of alice  friends and their friends
match (p:Person {name: 'Alice'})-[:FRIENDS*1..]-(f) 
where not f.name = 'Alice'
return  f

//Find all friends of friends one level down
match (alice:Person {name: 'Alice'})-[:FRIENDS*1..2]-(w)
return w

18. Count names
match (n) 
with count(n.name) as groupCount,n 
return groupCount, n.name

19.Count likes 
match (n)-[:LIKES]->(w) 
with count(n.name) as groupCount,n, collect(w.name) as wineName
return groupCount, n.name, wineName

20.Wines not reported on
match (w:Wine)
where not (w)<-[:REPORTED_ON]-(:Magazine)
return count(w), collect(w.name)

21.match friends
match (w:Person)-[:FRIENDS]->(p:Person) 
with [w.name, p.name] AS common 
return common

22. match people with wines
match (p:Person)
optional match (p)-[:LIKES]-(w:Wine)
with [p.name, collect(w.name)] AS common return common

23.Add/Update property
match (p:Person {name: 'Alice'})-[l:LIKES]->() 
set l.weight = 95
return l

24.Remove property
match (p:Person {name: 'Alice'})-[l:LIKES]->() 
set l.weight = null
return l

Exercise time:


Day 2:

Using Neo4j with cUrl:

check if it is running
1. curl -u neo4j:abc123 http://localhost:7474/db/data/

2.curl -u neo4j:abc123 -i -X POST http://localhost:7474/db/data/node \
-H "Content-Type: application/json" \
-d '{"name": "P.G. WodeHouse", "genre": "Brittish humour"}'

returns a json with different paths for created node
 
3.
curl -u neo4j:abc123 -i -X POST http://localhost:7474/db/data/node \
-H "Content-Type: application/json" \
-d '{"name": "Jeeves Takes Charge", "style": "short story"}'

4.
curl -u neo4j:abc123 -i -X POST http://localhost:7474/db/data/node/371/relationships \
-H "Content-Type: application/json" \
-d '{"to": "http://localhost:7474/db/data/node/372", "type": "WROTE", "data" : {"published" : "November 28,1916"}}'

5. 
curl -u neo4j:abc123 -i -X POST http://localhost:7474/db/data/node/371/paths \
-H "Content-Type: application/json" \
-d '{"to": "http://localhost:7474/db/data/node/372", "type": "WROTE", "algorithm" : "shortestPath"}'

//Other algoritms djikstra, allPath, allSimplePaths

6. Data cleanup
Open localhost:7474/browser
match (n) detach delete n
 press start
 example graphs
 movie graph
 
7.Four degrees of Kevin Bacon
MATCH (bacon:Person {name:"Kevin Bacon"})-[*1..4]-(hollywood)
RETURN DISTINCT hollywood

8. MATCH p=shortestPath(
     (bacon:Person {name:"Kevin Bacon"})-[*]-(meg:Person {name:"Meg Ryan"})
   )
   RETURN p


