exercise 1
1.
create (johannes:Person {name: 'Johannes Dolk', age:34})
create (johannes)-[:SIBLING {type: 'sister'}]->(klara:Person {name: 'Klara Dolk', age:37})
create (johannes)-[:SIBLING {type: 'sister'}]->(zandra:Person {name: 'Zandra Weldon', age:44})
create (johannes)-[:SIBLING {type: 'sister'}]->(chrillan:Person {name: 'Christel Kuren', age:52})
create (johannes)-[:PARENT {type: 'Father'}]->(dad:Person {name: 'Leif Kuren', age:73})
create (johannes)-[:PARENT {type: 'Mother'}]->(mom:Person {name: 'Katrin Dolk', age:69})
create (zandra)-[:PARENT {type: 'Mother'}]->(birgitta:Person {name: 'Birgitta Kuren', age:71})
create (chrillan)-[:PARENT {type: 'Mother'}]->(birgitta)
create (klara)-[:SIBLING {type: 'sister'}]->(zandra)
create (klara)-[:SIBLING {type: 'sister'}]->(chrillan)
create (zandra)-[:SIBLING {type: 'sister'}]->(chrillan)
create (chrillan)-[:MARRIED]->(ulle:Person {name: 'Ulrika Skogsby', age:52})
create (klara)-[:PARENT {type: 'Mother'}]->(mom)
create (klara)-[:PARENT {type: 'Father'}]->(dad)
create (chrillan)-[:PARENT {type: 'Father'}]->(dad)
create (zandra)-[:PARENT {type: 'Father'}]->(dad)
create (iris:Person {name: 'Iris Dolk' ,age:2})-[:PARENT {type: 'Mother'}]->(klara)
create (aniara:Person {name: 'Aniara Karlsson-Kuren', age:13})-[:PARENT {type: 'Mother'}]->(zandra)
create (eli:Person {name: 'Eli Karlsson-Kuren', age:10})-[:PARENT {type: 'Mother'}]->(zandra)
create (aniara)-[:PARENT {type: 'Father'}]->(jocke:Person {name: 'Joakim Karlsson', age:47})
create (eli)-[:PARENT {type: 'Father'}]->(jocke)
create (jim:Dog {name: 'Jim'})-[:OWNED_BY]->(chrillan)
create (fred:Dog {name: 'Fred'})-[:OWNED_BY]->(chrillan)
create (jim)-[:OWNED_BY]->(ulle)
create (fred)-[:OWNED_BY]->(ulle)
create (cat1:Cat {name: 'Cat1'})-[:OWNED_BY]->(zandra)
create (cat2:Cat {name: 'Cat2'})-[:OWNED_BY]->(zandra)


2.
match (p:Person {firstName: 'Eli'})-[:PARENT]->()-[:PARENT]->(p2:Person)
return p2

alt
match (p:Person {firstName: 'Eli'})-[:PARENT*2]->(p2)
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