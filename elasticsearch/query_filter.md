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

Hitta masters med titeln 'Gonna Gonna Give You Up':
[Query API](https://www.elastic.co/guide/en/elasticsearch/reference/current/search-request-body.html)
[Match Query](https://www.elastic.co/guide/en/elasticsearch/reference/current/query-dsl-match-query.html)
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
[Bool Query](https://www.elastic.co/guide/en/elasticsearch/reference/current/query-dsl-bool-query.html)
```bash
curl -XPOST 'localhost:9200/masters/_search?pretty' -H 'Content-Type: application/json' -d'
{
    "query": {
        "bool": {
            "must": [
                { "match": { "year": 2003 }},
                { "match": { "styles": "Techno"}}
            ]
        }
    },
    "size": 5
}
'
```

Hitta masters i stilen 'Hard Techno' från index 9000:
```bash
curl -XPOST 'localhost:9200/masters/_search?pretty' -H 'Content-Type: application/json' -d'
{
    "query": {
        "match": {
            "styles": "Hard Techno"
        }
    },
    "from": 9000,
    "size": 5
}
'
```

Men!! Vi ser i svaret träffar som inte innehåller style 'Hard Techno':
```json
{
    "total": 76628,
    "max_score": 7.847471,
    "hits": [
      {
        "_index": "masters",
        "_type": "master",
        "_id": "AVwMqO-G6MWb6D9962hi",
        "_score": 3.7286422,
        "_source": {
          "title": "High Alarm EP",
          "year": 1998,
          "artists": [
            "Mark Seven"
          ],
          "videos": [],
          "styles": [
            "Electronic",
            "Techno"
          ]
        }
      }
  ]
}
```

Ovanstående beror på att vi gör en textuell matchning. För exakt sökning behöver
vi använda 'term'-sökning istället.

Term-sökning på exakt 'Hard Techno':
[Term Query](https://www.elastic.co/guide/en/elasticsearch/reference/current/query-dsl-term-query.html)
```bash
curl -XPOST 'localhost:9200/masters/_search?pretty' -H 'Content-Type: application/json' -d'
{
    "query": {
        "term": {
            "styles.keyword": "Hard Techno"
        }
    },
    "from": 150,
    "size": 5
}
'
```

Räkna masters utgivna 2012:
[Count API](https://www.elastic.co/guide/en/elasticsearch/reference/current/search-count.html)
```bash
curl -XGET 'localhost:9200/masters/_count?pretty' -H 'Content-Type: application/json' -d'
{
    "query": {
        "term": { "year": 2012 }
    }
}
'
```

Aggregera masters per år:
[Search aggregation](https://www.elastic.co/guide/en/elasticsearch/reference/current/search-aggregations-bucket-terms-aggregation.html)
```bash
curl -XGET 'localhost:9200/masters/_search?pretty' -H 'Content-Type: application/json' -d'
{
	"size": 0,
    "aggs" : {
        "genres" : {
            "terms" : {
                "field" : "year",
                "size": 120,
                "order" : { "_term" : "asc" }
            }
        }
    }
}
'
```

Övningar:

1. Hur många masters har Rick Astley släppt?
2. Hur många masters släpptes mellan 1980 och 1989? [Range queries](https://www.elastic.co/guide/en/elasticsearch/reference/current/query-dsl-range-query.html)
3. Hitta alla masters av en artist med namn 'John' som släpptes före 2000.
4. Aggregera antalet masters per style.
