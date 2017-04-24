# Cygni competence - 7 databases - ElasticSearch

## Pre´reqs
Docker krävs för att starta ElasticSearch.

curl för kommandon från kommandoprompten.
- Win64: https://curl.haxx.se/download.html#Win64
- OSX: brew install curl

node för att populera ElasticSearch med testdata.
- Win64: https://nodejs.org/en/download/
- OSX: brew install node

Alla kommandon utgår från cygni-competence-7-databases/elasticsearch!

## Begrepp
- att indexera
- mappning (dynamic / explicit)
- hit
- score

## Starta ES:
```bash
*nix> docker run -p 9200:9200 -e "http.host=0.0.0.0" -e "transport.host=127.0.0.1" -v $(pwd)/elasticsearch.yaml:/usr/share/elasticsearch/config/elasticsearch.yml  docker.elastic.co/elasticsearch/elasticsearch:5.3.0
```
```bash
win> docker run -p 9200:9200 -e "http.host=0.0.0.0" -e "transport.host=127.0.0.1" -v %cd%\elasticsearch.yaml:/usr/share/elasticsearch/config/elasticsearch.yml  docker.elastic.co/elasticsearch/elasticsearch:5.3.0
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
