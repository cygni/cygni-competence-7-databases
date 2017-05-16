# Kibana
Kibana är ett web-gui för att ställa frågor mot ES. Det går också att visualisera data, skapa grafer och
sammansatta grafer.

Starta Kibana:
```bash
docker run -d --name kibana-cygni --net n-es-cygni -e XPACK_SECURITY_ENABLED=false -e ELASTICSEARCH_URL=http://es-cygni:9200 -p 5601:5601 docker.elastic.co/kibana/kibana:5.3.1
```

Det kan ta en bra stund för Kibana att initera sig men när allt är igång kommer du åt
tjänsten här: http://localhost:5601




### ToDo:
- styles per year

Match
Hitta 'Never gonna give you up'

Query vs Filter
Query: Hitta alla Techno låtar från 2002
Filter: "-"


Filterfrågor

Hitta alla
