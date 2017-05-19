1. Hur många masters har Rick Astley släppt?

```bash
curl -XGET 'localhost:9200/masters/_count?pretty' -H 'Content-Type: application/json' -d'
{
    "query": {
        "match": {
            "artists.keyword": {
                "query": "Rick Astley"
            }
        }
    }
}
'
```

2. Hur många masters släpptes mellan 1980 och 1989?

```bash
curl -XGET 'localhost:9200/masters/_count?pretty' -H 'Content-Type: application/json' -d'
{
    "query": {
        "range" : {
            "year" : {
                "gte" : 1980,
                "lte" : 1989
            }
        }
    }
}
'
```

3. Hitta alla masters av en artist med namn 'John' som släpptes före 2000.

```bash
curl -XGET 'localhost:9200/masters/_search?pretty' -H 'Content-Type: application/json' -d'
{
   "query": {
      "bool": {
         "must": [
            {
               "range": {
                  "year": {
                     "gte": 1,
                     "lte": 1999
                  }
               }
            },
            {
               "match": {
                  "artists": {
                     "query": "John"
                  }
               }
            }
         ]
      }
   },
   "size": 5
}
'
```

4. Aggregera antalet masters per style.
```bash
curl -XGET 'localhost:9200/masters/_search?pretty' -H 'Content-Type: application/json' -d'
{
    "size": 0,
    "aggs" : {
        "genres" : {
            "terms" : { "field" : "styles.keyword", "size": 1000 }
        }
    }
}
'
```

5. Hur många unika styles finns det?
```bash
curl -XGET 'localhost:9200/masters/_search?pretty' -H 'Content-Type: application/json' -d'
{
    "size": 0,
    "aggs": {

       "distinct_terms": {
            "cardinality": {
                "field": "styles.keyword"
            }
        }
    }
}
'
```
