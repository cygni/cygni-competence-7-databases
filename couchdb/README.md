# CouchDB
## Resources
- CouchDB API reference: [http://docs.couchdb.org/en/2.0.0/http-api.html](http://docs.couchdb.org/en/2.0.0/http-api.html)

## Before we start

Clone the repository into a directory of your choice.

```
$ git clone http://github.com/cygni/cygni-competence-7-databases
```

Navigate to cygni-competence-7-databases/couchdb/ and build the docker images we will use in this exercise. Also create a new docker network called 'couchdb'.

```
$ docker build -t cygni-couchdb-db db
$ docker build -t cygni-couchdb-shell .
$ docker network create couchdb
```

## Running CouchDB
Start a new container from the 'cygni-couch-db' image using the following command (WINDOWS or bash):

```
WINDOWS > docker run -d --name couch -p 5984:80 -v %cd%\db:/couchdb/data --net couchdb cygni-couchdb-db
BASH    $ docker run -d --name couch -p 5984:80 -v $(pwd)/db:/couchdb/data --net couchdb cygni-couchdb-db
```

Verify that your database is up and running at [localhost:5984/_utils][fauxton]. This should now open 'Fauxton', a web interface that comes with CouchDB.

![alt text][fauxton-first-page]

## Fauxton
Create a new database called 'music' from Fauxton. Your browser should now be looking at [http://localhost:5984/_utils/#/database/music/_all_docs](http://localhost:5984/_utils/#/database/music/_all_docs). From here, you can view, edit, create, or delete documents from the music database.

![alt text][fauxton-music-db]

Click on 'All Documents' -> '+' -> 'New document'. Fauxton will take you to its document editor where you manually can edit the initial value of the document. CouchDB already generated a unique identifier for you in the *_id* field. But you are free to change it. If the _id field is omitted, CouchDB will generate a new one before saving. So, just click 'Create Document' to save the new document.

![alt text][fauxton-new-document]

This should take you back to the view of all documents. Click the edit icon on the created document to go back to the editor.

![alt text][fauxton-all-docs]

Note the additional field called *_rev*. CouchDB generates a new value for this field each the document changes. The integer at the beginning represents the numerical revision of the document. As you will see later, to update a document in CouchDB, both the *_id* and the *_rev* fields must be provided. The update will only be accepted if the provided *_rev* field matches the current *_rev* field in the database. That is, CouchDB ensures that clients have read the latest version of a document when updating.

Now, delete the document we created. You can do this either from the view of all documents or from the document editor. Then create a brand new document. But this time, you should specify the id yourself. In the document editor, add the following json:

``` json
{
  "_id": "ramones",
  "name": "Ramones"
}
```

Save the document. Then go back and edit to add a 'albums' field:

``` json
"albums": [
    {
        "title": "Ramones",
        "year": 1976 
    },
    {
        "title": "Rocket to Russia",
        "year": 1977
    },
    {
        "title": "Road to Ruin",
        "year": 1978
    }
]
```

After saving, note the updated *_rev* field. It should start with '2'.

## Getting dirty with cURL
While the Fauxton interface provides a great overview of what features are available in CouchDB, it hides some of the details of how CouchDB works. We are going to use the command line tool *cURL* to communicate with CouchDB over its' RESTful API. Start the prepared shell using docker:

``` bash
WINDOWS > docker run -it --rm -v %cd%:/couch --net couchdb cygni-couchdb-shell
BASH    $ docker run -it --rm -v $(pwd):/couch --net couchdb cygni-couchdb-shell
```

Once inside the running container, issue a GET request to the root of the CouchDB endpoint. This will retrieve an informational message about the CouchDB instance.

``` bash
$ curl couch
{"couchdb":"Welcome","version":"2.0.0","vendor":{"name":"The ... 
```

Issuing a GET request on a database will retrieve information about the database including number of documents and number of operations.

``` bash
$ curl couch/music
{"db_name":"music","update_seq":"4-...
```

### Accessing documents
Documents in a database are exposed as resources on the path /{db}/{document-id}. See the [API reference][couch-api-document]. Issuing a GET request will retrieve the entire document: (you can pipe output to 'jq .' for pretty printing json)

```
$ curl couch/music/ramones | jq .
{
  "_id": "ramones",
  "_rev": "2-0a47eedbed7a829478ca490dbd9b2b6f",
  "name": "Ramones",
  "albums": [
    {
      "title": "Ramones",
      "year": 1976
    },
    {
      "title": "Rocket to Russia",
      "year": 1977
    },
    {
      "title": "Road to Ruin",
      "year": 1978
    }
  ]
}
$
```

To create a new document you can either PUT or POST. Issue a POST request to the music database to create a new document. CouchDB will respond with generated identifier and revision values:

```
$ curl -X POST couch/music/ \
-H "Content-Type: application/json" \
-d '{"name": "De Lyckliga Kompisarna"}'
{"ok":true,"id":"5dd92....","rev":"1-e4ce7...."}
```

Updates to existing documents are made using PUT requests. As mentioned earlier, we have to specify the *_id* and *_rev* fields of the latest version of the document we want to update. The *_id* value is specified in the URL: `couch/{db}/{id}`. The *_rev* value can be specified in:

- The json body with a field named `"_rev": {revision}`
- The If-Match HTTP header `If-Match: {revision}`
- The rev query parameter `localhost:5984/music/{id}?rev={revision}`

Add some albums to the 'De Lycklyga Kompisarna' document by issuing a PUT:

```
$ curl -X PUT 'couch/music/5dd92d287619477369ec87e4ef00d73b?rev=1-e4ce78586222cdb35465d4bea038238a' \
-H "Content-Type: application/json" \
-d '{
    "name": "De Lyckliga Kompisarna",
    "albums": [
        "Tomat",
        "Sagoland"
    ]
}'
{"ok":true,"id":"5dd92d287619477369ec87e4ef00d73b","rev":"2-027c7d133a0ccaf9596c6aa3dbe9e30f"}
```

CouchDB responds with 200 OK and the new revision field value. Try to execute the same command again, CouchDB will responds with an error specifying a 'Document update conflict'. This is because the provided revision value does not match the latest version.

Note how we also provided the 'name' field in the body, even though it was already in the document. That is because an update in CouchDB always completely replace the previous version of the document. It is not possible to simply append values.

Finally, delete the document using a DELETE request. Similar to updates, the latest revision has to be provided in the rev query parameter or in the If-Match HTTP header:

```
$ curl -X DELETE 'couch/music/5dd92d287619477369ec87e4ef00d73b/?rev=2-027c7d133a0ccaf9596c6aa3dbe9e30f'
{"ok":true,"id":"5dd92d287619477369ec87e4ef00d73b","rev":"3-451e59c722e3f8fd4ae8b7463efd12eb"}
```

Note how CouchDB responds with an updated revision. Instead of actually removing the document from disk, CouchDB inserts a new empty document on the same id and marks it as deleted. So, issuing a GET on the document id will return 404 Not Found with an additional 'reason' message specifying that the document has been deleted.

```
$ curl couch/music/5dd92d287619477369ec87e4ef00d73b
{"error":"not_found","reason":"deleted"}
```

### Exercises: CRUD with cURL
1. Use cURL to PUT a new artist document into the database with a specific *_id* of your choice.
2. Use cURL to create a new database with a name of your choice. Then delete it, also using cURL.
3. Use cURL to add the 'data/ramones.jpg' image as an [attachment][couch-api-attachments] to the 'Ramones' document. Then, look it up in Fauxton. (Hint: content type is image/jpeg, and binary data can be passed from using the --data-binary option)
4. Use cURL to retrieve the image attachment.

## Import data
Querying is not that fun unless we have some data that we can query. Execute the following command to add some music data to our database. It uses the CouchDB *_bulk_docs* handles to add a batch of documents in one request.

```
$ zcat data/jamendo-data.json.gz | \
curl -X POST couch/music/_bulk_docs/ \
-d @- -H "Content-Type: application/json"
```

The jamendo-data.json file contains artist data in the following format. 'random' is just a random 16-bit number assigned to each artist, album and track.

```
{
  "_id": "XXXX",
  "name": "Artist Name",
  "country": "CTR",
  "random": 33654
  "albums": [
    {
      "id": "YYYY",
      "name": "Album Name",
      "random": 52086
      "tracks": [
        {
          "id": "ZZZZ",
          "name": "Track Name",
          "random": 56475
          "tags": [
              {
                  "idstr": "tag",
                  "weight": 0.5
              }
          ],
        }
      ],
    }
  ],
}
```

## Views 
In CouchDB you access documents through *views*. Each database created in CouchDB comes with a few predefined views that allows you to query data from the documents. A view consists of a *map* and a *reduce* function that generates an ordered list of key-value pairs.

### Querying default views
The simplest predefined view is called *_all_docs* and is accessible through `localhost:5984/{db}/_all_docs`. Try it out by issuing a GET request on the music database.

```
$ curl couch/music/_all_docs
```

Append the query parameter *include_docs=true* to include the entire documents in the response.

```
$ curl couch/music/_all_docs?include_docs=true
```

### Writing views
Fauxton provides a pretty decent interface for writing your own views with map and reduce function. Views are stored in *design documents*. These are special documents that are prefixed with _design/. We are going to create a view that generates artist document ids keyed by artist name.

Go to [localhost:5984/_utils][fauxton] and go to the *music* database page. Now click the '+' sign next to 'Design Documents' and add a new view. Name the view 'by_name' and add it to a new design document called 'artists'.

![alt text][fauxton-music-new-view]

Write the following map function then hit 'Create Document' to save the view and view the results.

```javascript
function(doc) {
  if ('name' in doc) {
    emit(doc.name, doc._id);
  }
}
```

Before we head back to the command line, we are going to create another view that finds albums by name. Go back to the *music* database page and create a new design document named 'albums' with a view named 'by_name'. Add the following map function:

```javascript
function(doc) {
  if ('name' in doc && 'albums' in doc) {
    doc.albums.forEach(function(album){
      var key = album.title || album.name;
      var value = { by: doc.name, album: album };
      emit(key, value);
    });
  }
}
```

### Querying views
Views are be queried using the following path:

```
/{database}/_design/{design-document}/_view/{view-name}
```

So, for example to find artists by name:

```
$ curl couch/music/_design/artists/_view/by_name
```
And albums:
```
$ curl couch/music/_design/albums/_view/by_name
```

### Exercises: Views
1. Using the artists/by_name view, find all artists that start with the letter "J".
2. Create a new artist view that returns artist names keyed by their country. Then use cURL to find all artists from france ('FRA').
3. Create a new view that returns tracks keyed by their tag. Use cURL to inspect the result.
4. Remember the 'weight' field for tags? A track with a low weighted 'rock' tag might not be considered as 'rock'. Therefore, modify the above view so that it is possible to specify the minimum weight for the tag. Then find all tracks with a 'rock' tag weight of 0.8 or more.
5. Create a new view that returns artist documents keyed by their random number. Then use cURL to get a random artist. (Use $RANDOM in bash to generate a random nummber.)

## Advanced Views
Create a new design document for 'tags' with a 'by_name' view. Add the following map function

``` javascript
function (doc) {
  (doc.albums || []).forEach(function(album){
    (album.tracks || []).forEach(function(track){
      (track.tags || []).forEach(function(tag){
        emit(tag.idstr, 1);
      });
    });
  });
}
```

This mapper will generate rows keyed by tag name and the value '1' for each tag found. We are going to *reduce* these values with a count function. Select 'CUSTOM' from the dropdown menu, the default reduce function works for us. It will count the number of values for each key. 

``` javascript
function (keys, values, rereduce) {
  if (rereduce) {
    return sum(values);
  } else {
    return values.length;
  }
}
```

Execute the following command to retrieve the reduced result:

```
$ curl 'couch/music/_design/tags/_view/by_name?reduce=true&group=true'
```

It is not possible to sort reduced views by value directly from couch. This is something that has to be implemented in your application. For fun we can use jq to retrieve the top 10 most popular tags of our result set.

```
$ curl 'couch/music/_design/tags/_view/by_name?reduce=true&group=true' | \
jq .rows | jq 'sort_by(.value)' | jq reverse | jq .[0:10]
```

### Exercises: Advanced views
1. ?

## Changes API
CouchDB provides a [_change][couch-api-change] resource for each database which enables you to listen for changes.

```
$ curl couch/music/_changes
```

Will retrieve information about all changes in the 'music' database since creation. The result follows the following pattern:

``` json
{
  "results": [
    {
      "seq": <sequence-nr>,
      "id": <doc-id>,
      "changes": [
        {"rev": <last-update-rev>}
      ]
    }
  ]
}
```

Like other views you can specify the 'include_docs' and 'limit' query parameters.

### Exercises Changes API
1. Create a cURL request that gets the latest changes for a document with an id of your choice, e.g. 'nirvana'. Then go to fauxton and create/edit that document and execute your curl request again.
2. Create a cURL request that uses the *longpolling* feed to get document updates to the same document since the last update sequence. Go to fauxton and edit the document to see what happends.
3. Create a cURL request that uses the *continuous* feed to get document updates for the entire database since the last update sequence. Then go to fauxton and update documents at your will. Inspect the output from cURL.

## Replicating Data
CouchDB provides an easy way to replicate data between databases. 





[fauxton-first-page]: https://github.com/cygni/cygni-competence-7-databases/blob/screenshots/couchdb/fuxton-first-page.PNG?raw=true "Fauxton First Page"
[fauxton-new-document]: fauxton-new-document.png "Fauxton new document"
[fauxton-all-docs]: fauxton-all-docs.png "Fauxton all documents"
[fauxton-music-db]: https://github.com/cygni/cygni-competence-7-databases/blob/screenshots/couchdb/fauxton-music-db.png?raw=true "Fauxton 'music' database"
[fauxton-music-new-view]: https://github.com/cygni/cygni-competence-7-databases/blob/screenshots/couchdb/fauxton-music-new-view.png?raw=true "Creating new view"
[couch-download]: http://couchdb.apache.org/#download 
[fauxton]: http://localhost:5984/_utils/
[couch-api-change]: http://docs.couchdb.org/en/2.0.0/api/database/changes.html
[couch-api-document]: http://docs.couchdb.org/en/2.0.0/api/document/common.html 
[couch-api-attachments]: http://docs.couchdb.org/en/2.0.0/api/document/attachments.html