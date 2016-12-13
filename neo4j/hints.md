exercise 1
1.
create (johannes:Person {name: 'Johannes Dolk', age:34})
create (johannes)-[:SIBLING {type: 'sister'}]->(klara:Person {name: 'Klara', age:37})
create (johannes)-[:SIBLING {type: 'sister'}]->(zandra:Person {name: 'Zandra', age:44})
create (johannes)-[:SIBLING {type: 'sister'}]->(chrillan:Person {name: 'Christel', age:52})
create (johannes)<-[:PARENT_OF {type: 'Father'}]-(dad:Person {name: 'Leif', age:73})
create (johannes)<-[:PARENT_OF {type: 'Mother'}]-(mom:Person {name: 'Katrin', age:69})
create (zandra)<-[:PARENT_OF {type: 'Mother'}]-(birgitta:Person {name: 'Birgitta', age:71})
create (chrillan)<-[:PARENT_OF {type: 'Mother'}]-(birgitta)
create (klara)-[:SIBLING {type: 'sister'}]->(zandra)
create (klara)-[:SIBLING {type: 'sister'}]->(chrillan)
create (zandra)-[:SIBLING {type: 'sister'}]->(chrillan)
create (chrillan)-[:MARRIED]->(ulle:Person {name: 'Ulrika', age:52})
create (klara)<-[:PARENT_OF {type: 'Mother'}]-(mom)
create (klara)<-[:PARENT_OF {type: 'Father'}]-(dad)
create (chrillan)<-[:PARENT_OF {type: 'Father'}]-(dad)
create (zandra)<-[:PARENT_OF {type: 'Father'}]-(dad)
create (iris:Person {name: 'Iris' ,age:2})<-[:PARENT_OF {type: 'Mother'}]-(klara)
create (aniara:Person {name: 'Aniara', age:13})<-[:PARENT_OF {type: 'Mother'}]-(zandra)
create (eli:Person {name: 'Eli', age:10})<-[:PARENT_OF {type: 'Mother'}]-(zandra)
create (aniara)<-[:PARENT_OF {type: 'Father'}]-(jocke:Person {name: 'Joakim', age:47})
create (eli)<-[:PARENT_OF {type: 'Father'}]-(jocke)
create (jim:Pet {name: 'Jim', type: 'dog'})-[:OWNED_BY]->(chrillan)
create (fred:Pet {name: 'Fred', type: 'dog'})-[:OWNED_BY]->(chrillan)
create (jim)-[:OWNED_BY]->(ulle)
create (fred)-[:OWNED_BY]->(ulle)
create (cat1:Pet {name: 'Cat1', type: 'cat'})-[:OWNED_BY]->(zandra)
create (cat2:Pet {name: 'Cat2', type: 'cat'})-[:OWNED_BY]->(zandra)


2.
match (p:Person {name: 'Eli'})-[:PARENT]->()-[:PARENT]->(p2:Person)
return p2

alt
match (p:Person {name: 'Eli'})-[:PARENT*2]->(p2)
return p2

3.
match (p:Person)<-[:OWNED_BY]-(a) return p, a

5.
match (p:Person)
return p
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