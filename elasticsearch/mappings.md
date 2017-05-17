# Mappningsfiler
Mappningsfiler beskriver datat som ska indexeras av Elasticsearch.
Om man vill ändra en mappningsfil måste datat generellt indexeras om i ett nytt index.
Det finns några undantag: att lägga nya fält går bra.

## En enkel mappning
Oftast definierar man mappningar i samband med att man skapar indexet:

```bash
curl -XPUT 'localhost:9200/masters-2?pretty' -H 'Content-Type: application/json' -d'
{
    "master": {
        "properties": {
          "title" : { "type": "text", "copy_to":  "all_names"},
          "year": { "type": "short" },
          "artists": { "type": "text", "copy_to":  "all_names" },
          "videos": {
            "properties": {
              "duration": { "type": "short" },
              "title": { "type": "text", "copy_to":  "all_names" }
            }
          },
          "styles": { "type": "keyword" },
          "all_names": {
            "type": "text"
          }
        }
    }
}
'
```

Dokumentation för mappningar: https://www.elastic.co/guide/en/elasticsearch/reference/5.3/mapping.html

## Indexera om data

```bash
curl -XPOST 'localhost:9200/_reindex?pretty' -H 'Content-Type: application/json' -d'
{
  {
    "source": {
      "index": "masters"
    },
    "dest": {
      "index": "masters-2"
    }
  }
}
'
```

Är indexet stort så tar omindexeringen några minuter.

Dokumentation för reindex: https://www.elastic.co/guide/en/elasticsearch/reference/5.3/docs-reindex.html
