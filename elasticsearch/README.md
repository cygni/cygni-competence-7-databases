# Cygni competence - 7 databases - ElasticSearch

## Förberedelser
Följ alla instruktioner nedan som en förberedelse inför kurstillfället! Se
[FAQ](https://github.com/cygni/cygni-competence-7-databases/tree/master/elasticsearch#faq) för vanligt förekommande problem.


## Pre´reqs

Docker krävs för att starta Elasticsearch och Kibana.
- Win64: https://store.docker.com/editions/community/docker-ce-desktop-windows
- OSX: https://store.docker.com/editions/community/docker-ce-desktop-mac

curl för kommandon från kommandoprompten.
- Win64: https://curl.haxx.se/download.html#Win64
- OSX: brew install curl

node för att populera ElasticSearch med testdata.
- Win64: https://nodejs.org/en/download/
- OSX: brew install node

Hämta docker images och skapa nätverk:
```
$ docker pull docker.elastic.co/elasticsearch/elasticsearch:5.3.1
$ docker pull docker.elastic.co/kibana/kibana:5.3.1
$ docker network create n-es-cygni
```

> **_Alla kommandon utgår från mappen cygni-competence-7-databases/elasticsearch!_**

## Starta Elasticsearch
```bash
*nix> docker run -d --name es-cygni --net n-es-cygni -p 9200:9200 -e "http.host=0.0.0.0" -e "transport.host=127.0.0.1" -v $(pwd)/elasticsearch.yaml:/usr/share/elasticsearch/config/elasticsearch.yml  docker.elastic.co/elasticsearch/elasticsearch:5.3.1
```
```bash
win> docker run -d --name es-cygni --net n-es-cygni -p 9200:9200 -e "http.host=0.0.0.0" -e "transport.host=127.0.0.1" -v %cd%\elasticsearch.yaml:/usr/share/elasticsearch/config/elasticsearch.yml  docker.elastic.co/elasticsearch/elasticsearch:5.3.1
```

## Postman
Postman är en plugin till Chrome som erbjuder ett grafiskt gränssnitt för REST-anrop. Den kan hämtas här: [https://www.getpostman.com/]

Under Body välj raw och JSON (application/json) som format.
![Postman example][postman-example]

## Läsa in testdata (Elasticsearch måste vara igång)
Det är drygt en miljon poster som ska läsas in, det tar
några minuter!
```bash
unzip data/masters_all.json.zip -d data/
cd tools
npm install
node loader.js
```

##  Starta Kibana
```bash
docker run -d --name kibana-cygni --net n-es-cygni -e XPACK_SECURITY_ENABLED=false -e ELASTICSEARCH_URL=http://es-cygni:9200 -p 5601:5601 docker.elastic.co/kibana/kibana:5.3.1
```

Det kan ta en bra stund för Kibana att initera sig men när allt är igång kommer du åt
tjänsten här: http://localhost:5601

### Kibana, val av index
Kibana kräver att man väljer ett default-index att arbeta mot. Se screenshot nedan:

![alt][kibana-select-index]

## Verifiera
Säkerställ att Elasticsearch har gått igång ordentligt samt att inläsningen av
testdatat gått bra:

```bash
curl -XPOST 'localhost:9200/masters/_search?pretty' -H 'Content-Type: application/json' -d'
{
    "query": {
        "match" : { "title": "Never Gonna Give You Up"}
    },
    "size": 5
}
'
```

## FAQ

### Elasticsearch docker container dör.
För lite minne, Elasticsearch och Kibana tillsammans kräver minst 4GB.

### Elasticsearch contianern går inte att starta.
I Windows: problem med sökvägar som innehåller mellanslag.

### http://localhost:9200 svarar inte.
Hänt i Windows: exponerad port binds inte till localhost utan till IP-numret.

Byt då alla exempel-url:ar från localhost till ditt IP. tools/loader.js behöver
också redigeras:
```javascript
const client = elasticsearch.Client({
    hosts: '<ditt ip-nr>:9200',
    httpAuth: 'elastic:changeme',
});
```

[postman-example]: https://github.com/cygni/cygni-competence-7-databases/blob/screenshots/elasticsearch/postman.png?raw=true "Postman example"

[kibana-select-index]: https://github.com/cygni/cygni-competence-7-databases/blob/screenshots/elasticsearch/kibana-select-index.png?raw=true "Kibana välj index"
