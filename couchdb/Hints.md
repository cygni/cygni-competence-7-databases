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

# Exercises: Views

### 1. Using the artists/by_name view, find all artists that start with the letter "J"

Use the 'startkey' and 'endkey' parameters in the GET request:

```
$ curl 'couch/music/_design/artists/_view/by_name?startkey="J"&endkey="K"'
```

### 2. Create a new artist view that returns artist names keyed by their country. Then use cURL to find all artists from france ('FRA').
In the _design/artists document. Add a new view called 'by\_country' with the following mapper function:

``` json
function(doc) {
  if('country' in doc && 'name' in doc) {
    emit(doc.country, doc.name)
  }
}
```

Then, results can be filtered by key using the 'key' query parameter.

```
$ curl 'couch/music/_design/artists/_view/by_country?key="FRA"'
```
### 3. Create a new view that returns tracks keyed by their tag. Use cURL to retrieve all tracks tagged with 'rock'.
Create a new _design/tracks document. Add a new view called 'by\_tag' with the following mapper function.

``` javascript
function(doc) {
  (doc.albums || []).forEach(function(album) {
    (album.tracks || []).forEach(function(track) {
      (track.tags || []).forEach(function(tag) {
        emit(tag.idstr, {track: track.name, artist: doc.name});
      })
    })
  })
}
```

You can of course choose if you want to include more fields in the value parameter.

The following request will get all tracks with the 'rock' tag:

``` bash
$ curl 'couch/music/_design/tracks/_view/by_tag?key="rock"'
```

### 4.
CouchDB supports arrays as keys, so include the ```tag.weight``` in the key:

``` bash
function(doc) {
  (doc.albums || []).forEach(function(album) {
    (album.tracks || []).forEach(function(track) {
      (track.tags || []).forEach(function(tag) {
        emit([tag.idstr, tag.weight], {track: track.name, artist: doc.name});
      })
    })
  })
}
```


The following request will get all tracks with a 'rock' tag weight in the range of [0.8, 1.01[:

``` bash
curl 'couch/music/_design/tracks/_view/by_tag?startkey=["rock",0.8]&endkey=["rock",1.01]' -g
```

The ```-g``` option turns off curl globbing so that we don't have to escape the '[' and ']' characters.