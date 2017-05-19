# Kibana
Kibana är ett web-gui för att ställa frågor mot Elasticsearch. Det går också att visualisera data, skapa grafer och
sammansatta grafer.

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
3. Hitta alla masters av en artist vars namn innehåller 'John' och som släpptes före 2000.

## Övningar grafer
1. Gör en Tag Cloud över styles:

![alt][tagcloud-styles]

2. Gör en Bar Chart över styles:

![alt][bar-styles]

3. Gör en Bar Chart över masters per år och de fem vanligaste styles inom varje år:

![alt][year-sub-styles]


[kibana-simple-search]: https://github.com/cygni/cygni-competence-7-databases/blob/screenshots/elasticsearch/kibana-simple-search.png?raw=true "Kibana fritextsökning"

[kibana-field-search]: https://github.com/cygni/cygni-competence-7-databases/blob/screenshots/elasticsearch/kibana-field-search.png?raw=true "Kibana fältsökning"

[kibana-and-search]: https://github.com/cygni/cygni-competence-7-databases/blob/screenshots/elasticsearch/kibana-and-search.png?raw=true "Kibana boolsksökning"

[kibana-range-search]: https://github.com/cygni/cygni-competence-7-databases/blob/screenshots/elasticsearch/kibana-range-search.png?raw=true "Kibana rangesökning"

[tagcloud-styles]: https://github.com/cygni/cygni-competence-7-databases/blob/screenshots/elasticsearch/tagcloud-styles.png?raw=true "Tag Cloud över styles"

[bar-styles]: https://github.com/cygni/cygni-competence-7-databases/blob/screenshots/elasticsearch/bar-styles.png?raw=true "Masters per style"

[year-sub-styles]: https://github.com/cygni/cygni-competence-7-databases/blob/screenshots/elasticsearch/bar-year-sub-styles.png?raw=true "Masters per år, sub styles"
