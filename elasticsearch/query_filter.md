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

## Querybaserad sökning

Hitta masters med titeln 'Gonna miss my love'
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

Hitta alla masters utgivna 2003 i stilen Techno:
```bash
curl -XPOST 'localhost:9200/masters/_search?pretty' -H 'Content-Type: application/json' -d'
{
    "query": {
        "bool": {
            "must": [
                { "match": { "year": 2003 }},
                { "term": { "styles": "Techno"}}
            ]
        }
    },
    "size": 5
}
'
```

Term-sökning på exakt 'Hard Techno':
```bash
curl -XPOST 'localhost:9200/masters/_search?pretty' -H 'Content-Type: application/json' -d'
{
    "query": {
        "match": {
            "styles.keyword": {
                "query": "Hard Techno"
            }
        }
    },
    "size": 5
}
'
```

Räkna masters utgivna 2012:
```bash
curl -XGET 'localhost:9200/masters/_count?pretty' -H 'Content-Type: application/json' -d'
{
    "query": {
        "term": { "year": 2012 }
    }
}
'
```

Övningar:

1. Hur många masters har Rick Astley släppt?
2. Hur många masters släpptes mellan 1980 och 1989?
3. Hitta alla masters av en artist med namn 'John' som släpptes före 2000.
4.



******************

Visa Skillnad Query / Filter
Visa Exempel Query
    - när använda Query (techo, hard techno)
Visa Exempel Filter
    - när använda filter

Övningar Query/Filter

Visa Mappning
localhost:9200/masters

Uppdatera mappning
Put /masters-2
{
  "mappings": {
    "master": {
      "properties": {
        "title": {
          "type": "text"
        }
      }
    }
  }
}

******************
