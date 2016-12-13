exercise 1
1.
match (joh:Person {name: 'Johannes'})
match (kla:Person {name: 'Klara'})
match (zan:Person {name: 'Zandra'})
match (chr:Person {name: 'Christel'})
create (leif:Person {name: 'Leif', age: 73})-[:PARENT_OF {type: 'father'}]->(joh)
create (leif)-[:PARENT_OF {type: 'father'}]->(kla)
create (leif)-[:PARENT_OF {type: 'father'}]->(zan)
create (leif)-[:PARENT_OF {type: 'father'}]->(chr)
return leif

2.
match (zan:Person {name: 'Zandra'})
match (chr:Person {name: 'Christel'})
create (:Pet {name: 'Jim', type: 'Dog'})-[:OWNED_BY]->(chr)
create (:Pet {name: 'Fred', type: 'Dog'})-[:OWNED_BY]->(chr)
create (:Pet {name: 'Revolver', type: 'Cat'})-[:OWNED_BY]->(zan)
create (:Pet {name: 'Cat2', type: 'Cat'})-[:OWNED_BY]->(zan)


3.
match (p:Person {name: 'Eli'})<-[:PARENT_OF]-()<-[:PARENT_OF]-(p2:Person)
return p2

alt
match (p:Person {name: 'Eli'})<-[:PARENT_OF*2]-(p2)
return p2

4.
match (p:Person)<-[:OWNED_BY]-(a:Pet) return p, a

5.
match (p:Person)
return p.name as name, p.age as age
order by p.age desc



exercise 2
1. 
MATCH (p1:Person)
WITH p1
MATCH p = (p1)-[:ACTED_IN]->()
WITH p1.name AS p1, COUNT(p) AS links, p
RETURN p1, count(links) AS row
ORDER BY row desc

2.
match (p1:Person)-[:ACTED_IN]->(m:Movie)<-[:ACTED_IN]-(p2:Person)
where p1.name < p2.name
with p1,p2, count(m) as movies
return p1.name,p2.name, movies
order by movies desc, p1.name, p2.name 

3.
match (tom:Person {name: 'Tom Hanks'})
match (tom)-[:ACTED_IN]->()<-[:DIRECTED]-(p2:Person)
with p2
with 2016 - p2.born as age, p2.name as p2 
order by age desc
return distinct p2, age

4.
match (p1:Person {name: 'Tom Hanks'})-[:ACTED_IN]->(m1:Movie)<-[:ACTED_IN]-(p2:Person)-[:ACTED_IN]->(m2:Movie)<-[:ACTED_IN]-(p3:Person {name: 'Meg Ryan'})
return p2.name, m1.title, m2.title



LOAD CSV FROM "file:///Users/johannesdolk/Work/eniro/productmaster/server/src/main/resources/cypher/products/online/searchWord.csv" AS line
CREATE (item:_Item {itemId: line[0], key: line[1], value: line[2]});