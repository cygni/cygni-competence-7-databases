## cURL away
### 1. Use cURL to PUT a new document into the database with a specific *_id* of your choice.

To create a document with PUT, append the desired identifier to the URL.

```
$ curl -X PUT localhost:5984/music/ramones/ \
-H "Content-Type: application/json" \
-d '{"name": "Ramones"}'
```

Note that it is also possible to specify your own value for the *_id* field when using POST. Just add it to the json body.

```
$ curl -X POST localhost:5984/music \
-H "Content-Type: application/json" \
-d '{    
  "_id": "Ramones",
  "name": "Ramones"
}'
```


### 2. Use cURL to create a new database with a name of your choice. Then delete it, also using cURL.

```
$ curl -X PUT localhost:5984/movies
```

```
$ curl -X DELETE localhost:5984/movies
```

### 3. Create a new document that contains a text document as an attachment. Lastly, craft and execute a cURL request that will return the document attachment.
```
$ curl -X PUT localhost:5984/music/ramones/image \ 
-H "Content-Type: image/jpeg" \
-H "If-Match: 2-1efc76c557f3b3cd46a3fce33d0849e9" \
--data-binary @ramones.jpg
{"ok":true,"id":"5dd92d287619477369ec87e4ef005847","rev":"3-df6fb461ef387bd7873d8e34255fafb7"}
```