## Vanliga operationer i ES (via curl eller Postman)

### Lista alla index
```bash
curl -X GET 'localhost:9200/_cat/indices/*?v=&s=index'
```

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
