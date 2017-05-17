# Kibana
Kibana är ett web-gui för att ställa frågor mot ES. Det går också att visualisera data, skapa grafer och
sammansatta grafer.

Starta Kibana:
```bash
docker run -d --name kibana-cygni --net n-es-cygni -e XPACK_SECURITY_ENABLED=false -e ELASTICSEARCH_URL=http://es-cygni:9200 -p 5601:5601 docker.elastic.co/kibana/kibana:5.3.1
```

Det kan ta en bra stund för Kibana att initera sig men när allt är igång kommer du åt
tjänsten här: http://localhost:5601

## Val av index
Kibana kräver att man väljer ett default-index att arbeta mot. Se screenshot nedan:
![alt][kibana-select-index]

## Fritextsökning
Det går bra att skriva en vanlig sträng i sökfältet. Då söks i alla indexerade fält.
![alt][kibana-simple-search]

## Fältsökning
Genom att skriva fältets namn - kolon - sökord så söks bara i det fältet.
![alt][kibana-field-search]

## Boolsksökning
Sökparametrar kan kombineras med AND:
title: demon AND artists: E-Type
![alt][kibana-and-search]

## Rangesökning
Görs så här: year: [ 0 TO 2000]
![alt][kibana-range-search]

## Övningar frågor
1. Hur många masters har Rick Astley släppt?
2. Hur många masters släpptes mellan 1980 och 1989?
3. Hitta alla masters av en artist med namn 'John' som släpptes före 2000.

## Övningar Grafer
1. Gör en Tag Cloud över styles:
![alt][tagcloud-styles]

2. Gör en Bar Chart över styles:
![alt][bar-styles]

3. Gör en Bar Chart över masters per år och de fem vanligaste styles inom varje år:
![alt][year-sub-styles]



### ToDo:
- styles per year

Match
Hitta 'Never gonna give you up'

Query vs Filter
Query: Hitta alla Techno låtar från 2002
Filter: "-"


Filterfrågor

Hitta alla


[kibana-select-index]: https://github.com/cygni/cygni-competence-7-databases/blob/screenshots/elasticsearch/kibana-select-index.png?raw=true "Kibana välj index"

[kibana-simple-search]: https://github.com/cygni/cygni-competence-7-databases/blob/screenshots/elasticsearch/kibana-simple-search.png?raw=true "Kibana fritextsökning"

[kibana-field-search]: https://github.com/cygni/cygni-competence-7-databases/blob/screenshots/elasticsearch/kibana-field-search.png?raw=true "Kibana fältsökning"

[kibana-and-search]: https://github.com/cygni/cygni-competence-7-databases/blob/screenshots/elasticsearch/kibana-and-search.png?raw=true "Kibana boolsksökning"

[kibana-range-search]: https://github.com/cygni/cygni-competence-7-databases/blob/screenshots/elasticsearch/kibana-range-search.png?raw=true "Kibana rangesökning"

[tagcloud-styles]: https://github.com/cygni/cygni-competence-7-databases/blob/screenshots/elasticsearch/tagcloud-styles.png?raw=true "Tag Cloud över styles"

[bar-styles]: https://github.com/cygni/cygni-competence-7-databases/blob/screenshots/elasticsearch/bar-styles.png?raw=true "Masters per style"

[year-sub-styles]: https://github.com/cygni/cygni-competence-7-databases/blob/screenshots/elasticsearch/bar-year-sub-styles.png?raw=true "Masters per år, sub styles"
