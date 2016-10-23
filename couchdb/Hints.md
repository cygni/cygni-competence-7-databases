# CRUD with cURL

### 1. Use cURL to PUT a new artist document into the database with a specific _id of your choice.
To create a document with PUT, append the desired identifier to the URL:

``` bash
$ curl -X PUT couch/music/the-clash/ -H "Content-Type: application/json" \
-d '{"name": "The Clash"}'
```

Note that it is also possible to specify your own value for the *_id* field when using POST. Just add it to the json body.

``` bash
$ curl -X POST couch/music -H "Content-Type: application/json" \
-d '{    
  "_id": "the-clash",
  "name": "The Clash"
}'
```


### 2. Use cURL to create a new database with a name of your choice. Then delete it, also using cURL.
``` bash
$ curl -X PUT couch/movies
```

``` bash
$ curl -X DELETE couch/movies
```

### 3. Use cURL to add the 'data/ramones.jpg' image as an [attachment][couch-api-attachments] to the 'Ramones' document. Then, look it up in Fauxton.

``` bash
$ curl -X PUT couch/music/ramones/cover -H "Content-Type: image/jpeg" \
-H "If-Match: 2-1efc76c557f3b3cd46a3fce33d0849e9" \
--data-binary @data/ramones.jpg
```

### 4. Use cURL to retrieve the image attachment.
``` bash
$ curl couch/music/ramones/cover -o ramones-cover.jpg
```


