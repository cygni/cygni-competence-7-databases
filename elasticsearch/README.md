# Cygni competence - 7 databases - ElasticSearch

## Pre´reqs
Docker krävs för att starta ElasticSearch.

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

Alla kommandon utgår från cygni-competence-7-databases/elasticsearch!

## Begrepp
- att indexera
- mappning (dynamic / explicit)
- hit
- score

## Starta ES:
```bash
*nix> docker run -d --name es-cygni --net n-es-cygni -p 9200:9200 -e "http.host=0.0.0.0" -e "transport.host=127.0.0.1" -v $(pwd)/elasticsearch.yaml:/usr/share/elasticsearch/config/elasticsearch.yml  docker.elastic.co/elasticsearch/elasticsearch:5.3.1
```
```bash
win> docker run -d --name es-cygni --net n-es-cygni -p 9200:9200 -e "http.host=0.0.0.0" -e "transport.host=127.0.0.1" -v %cd%\elasticsearch.yaml:/usr/share/elasticsearch/config/elasticsearch.yml  docker.elastic.co/elasticsearch/elasticsearch:5.3.1
```

## Vanliga operationer i ES (via curl eller PostMan)

### Skapa ett dokument
Skapar ett nytt dokument med automatisk mappning. 'twitter' är indexet, 'tweet'
är dokument-typen. 1 är dokumentets ID. ?pretty gör svaret finformaterat!

```bash
curl -XPUT 'localhost:9200/twitter/tweet/1?pretty' -H 'Content-Type: application/json' -d'
{
    "user" : "kimchy",
    "post_date" : "2009-11-15T14:12:12",
    "message" : "trying out Elasticsearch"
}
'
```
### Hämta ett dokument
```bash
curl -XGET 'localhost:9200/twitter/tweet/1?pretty'
```

### Hämta mappning för ett index
```bash
curl -XGET 'localhost:9200/twitter/_mapping?pretty'
```

### Skapa en explicit mappning
```bash
curl -XPUT 'localhost:9200/twitter?pretty' -H 'Content-Type: application/json' -d'
{
  "mappings": {
    "tweet": {
      "properties": {
        "message": {
          "type": "text"
        }
      }
    }
  }
}
'
curl -XPUT 'localhost:9200/twitter/_mapping/user?pretty' -H 'Content-Type: application/json' -d'
{
  "properties": {
    "name": {
      "type": "text"
    }
  }
}
'
curl -XPUT 'localhost:9200/twitter/_mapping/tweet?pretty' -H 'Content-Type: application/json' -d'
{
  "properties": {
    "user_name": {
      "type": "text"
    }
  }
}
'
```

```bash
curl -XGET 'localhost:9200/twitter/tweet/_search?pretty' -H 'Content-Type: application/json' -d'
{
    "query": {
        "match": {
            "user": "kimchy"
        }
    }
}
'
```

## Läsa in testdata (ElasticSearch måste vara igång)
```bash
unzip data/masters_all.json.zip -d data/
cd tools
npm install
node loader.js
```
## Om testdatat
Från Discogs (https://data.discogs.com) har vi använt en delmängd av deras data som kallas Master Release.
Testfilen innehåller 1 134 618 st JSON-dokument. Här är ett exempel på ett dokument:
```json
{
  "title": "Psyche EP",
  "year": 2002,
  "artists": [
    "Samuel L Session"
  ],
  "videos": [
    {
      "duration": 376,
      "title": "Samuel L. Session - Psyche Part 1"
    },
    {
      "duration": 419,
      "title": "Samuel L. Session - Psyche Part 2"
    },
    {
      "duration": 118,
      "title": "Samuel L. Session - Arrival"
    }
  ],
  "styles": [
    "Electronic",
    "Techno",
    "Tribal"
  ]
}
```
Det handlar alltså om släppta låtar. Observera att originalformatet från Discogs är i XML,
vi har formaterat om det till JSON för enklare indexering i ElasticSearch.

## Kibana
Kibana är ett web-gui för att ställa frågor mot ES. Det går också att visualisera data, skapa grafer och
sammansatta grafer.

Starta Kibana:
```bash
docker run -d --name kibana-cygni --net n-es-cygni -e XPACK_SECURITY_ENABLED=false -e ELASTICSEARCH_URL=http://es-cygni:9200 -p 5601:5601 docker.elastic.co/kibana/kibana:5.3.1
```

Det kan ta en bra stund för Kibana att initera sig men när allt är igång kommer du åt
tjänsten här: http://localhost:5601
