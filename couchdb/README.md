# CouchDB
## Resources
- CouchDB API reference: [http://docs.couchdb.org/en/2.0.0/http-api.html](http://docs.couchdb.org/en/2.0.0/http-api.html)

## Before we start
Before we start, please make sure you are able to run CouchDB 2.0 on your machine. We recommend using Docker. Use the official docker image 'couchdb' and start a new container named 'db' using the following command in bash:
```
$ docker run -d --name db -v $(pwd):/home/couchdb/dev/lib -p 5984:15984 couchdb --with-admin-party-please 
```

Or if you are on windows:
```
> docker run -d --name db -v %cd%:/home/couchdb/dev/lib -p 5984:15984 couchdb --with-admin-party-please
```

### Verify
To verify that your database is up and running at port 5984, go to [localhost:5984/_utils][fauxton]. This opens 'Fauxton', the web interface that comes with CouchDB.

- Open browser and go to: [localhost:5984/_utils][fauxton]
 
![alt text][fauxton-first-page]

## CRUD with Fauxton
We'll start of by doing some CRUD operations with Fauxton and cURL. The first thing we'll need to do is to create a new database. This can be done using Fauxton.

- From Fauxton, create a new database called 'music'

Your browser should now be looking at [http://localhost:5984/_utils/#/database/music/_all_docs](http://localhost:5984/_utils/#/database/music/_all_docs). This page shows you all documents for the 'music' database. From here, you can view existing or create new documents.

![alt text][fauxton-music-db]

Click the '+' next to 'All Documents' and create a new document. A new view will open. CouchDB generates a new unique identifier for you by default. The identifier is specified by the *_id* field. You are free to change it. If the *_id* field is completely omitted in the new document, CouchDB will generate a new one before saving. For now, just click 'Create Document' to save the new document.

- Create a new empty document

This will take you back to the list of documents in 'music'. Double click the the header of the document or click the 'edit' icon in the top-right corner. This takes you to the document editor. 

Note the additional field called *_rev* in the new document. CouchDB will generate a new value for this field each the document changes. The integer at the beginning represents the numerical revision of the document. In order to update a document in CouchDB, both the *_id* and the *_rev* fields must be provided. Only if the provided *_rev* field matches the *_rev* field in the database will the update be accepted. That is, CouchDB ensures that clients have read the latest version of a document when updating.

To update a document in Fauxton, simply modify the json in the document editor and hit "Save Changes".

- Add a new field: `"name": "Ramones"`

Note the updated *_rev* field. Go ahead and add some albums to the document as well.

- Add a new albums field:
```
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

## Getting dirty with cURL
While the Fauxton interface provides a great overview of what features are available in CouchDB, it hides some details of how things work. Let's drop down to the command line and cURL to investigate how to communicate with CouchDB using its' RESTful API. You can use any REST-client available, such as Postman or Advanced Rest Client if you'd like. However, all examples will be shown as cURL commands.

Issuing a GET request to the root will retrieve an informational message about the CouchDB instance.

```
$ curl localhost:5984
```

Issuing a GET request on a database will retrieve information about the database including number of documents and number of operations.

```
$ curl localhost:5984/music
```

### Read documents with GET
To read a specific document, append the *_id* to the URL. You may copy the value from Fauxton.

```
$ curl localhost:5984/music/{id}
```

### Create documents with PUT or POST
To create a new document you can use PUT or POST. Issue a POST request to the music database to create a new document. CouchDB will respond with generated identifier and revision values.

```
$ curl -X POST localhost:5984/music/ \
-H "Content-Type: application/json" \
-d '{"name": "De Lyckliga Kompisarna"}'
{"ok":true,"id":"5dd92d287619477369ec87e4ef00d73b","rev":"1-e4ce78586222cdb35465d4bea038238a"}
```

### Update documents with PUT
We will use a PUT request to update existing document. When we are updating documents in CouchDB, we have to specify the *_id* and *_rev* fields in the latest version of the document we want to update. The *_id* value is simply specified in the URL using RESTful conventions: `localhost:5984/music/{id}`. The *_rev* value can be specified in three ways:

- In the json body with a field named `"_rev": {revision}`
- In the If-Match HTTP header `If-Match: {revision}`
- In the rev query parameter `localhost:5984/music/{id}?rev={revision}`

Issue a PUT request to add some albums to the 'De Lyckliga Kompisarna' artist document. First you might have to GET `localhost:5984/music/{id}` to gain access to the latest *_rev* value. Then you can choose freely how you want to specify the revision. The following command updates using the rev query parameter.

```
$ curl -X PUT 'localhost:5984/music/5dd92d287619477369ec87e4ef00d73b?rev=1-e4ce78586222cdb35465d4bea038238a' \
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

CouchDB will respond with 200 OK and the new revision field value. Try to execute the same command again, CouchDB will responds with an error specifying a 'Document update conflict'. This is because the provided revision value does not match the latest version.

Note how we also provided the 'name' field in the body, even though it was already in the document. That is because an update in CouchDB always completely replace the previous version. You can not simply append values to a document. I.e., if we had omitted the 'name' field, the document would only contain the 'albums' field. Along with the *_id* and *_rev* fields. 

### Removing documents with DELETE
Finally, we will delete the document using a DELETE request. Similar to PUT, you will specify the document id in the URL. The latest revision also have to be provided in the rev query parameter or in the If-Match HTTP header.

```
$ curl -X DELETE 'localhost:5984/music/5dd92d287619477369ec87e4ef00d73b/?rev=2-027c7d133a0ccaf9596c6aa3dbe9e30f'
{"ok":true,"id":"5dd92d287619477369ec87e4ef00d73b","rev":"3-451e59c722e3f8fd4ae8b7463efd12eb"}
```

CouchDB will respond with an updated revision. Instead of actually removing the document from disk, CouchDB simply inserts a new empty document on the same id and marks it as deleted. So issuing a GET on the document id will return 404 Not Found with additional information specifying that the document has been deleted.

```
$ curl localhost:5984/music/5dd92d287619477369ec87e4ef00d73b
{"error":"not_found","reason":"deleted"}
```

### cURL away
1. Use cURL to PUT a new document into the database with a specific *_id* of your choice.
2. Use cURL to create a new database with a name of your choice. Then delete it, also using cURL.
3. Create a new document that contains a jpg image as an attachment. Lastly, craft and execute a cURL request that will return the attachment.

## Creating and Querying Views 
In CouchDB you access documents through *views*. Each database created in CouchDB comes with a few predefined views that allows you to query data from the documents. A view consists of a *map* and a *reduce* function that generates an ordered list of key-value pairs.

### Querying default views
The simplest predefined view is called *_all_docs* and is accessible through `localhost:5984/{db}/_all_docs`. Issue a GET request on the music database.

```
$ curl localhost:5984/music/_all_docs
```

Appends the query parameter *include_docs=true* to include the entire documents in the response.

```
$ curl localhost:5984/music/_all_docs?include_docs=true
```

### Writing views
Fauxton provides a pretty decent interface for writing your own views with map and reduce function. Views are stored in *design documents*. These are special documents that are prefixed with _design/. We are going to create a view that generates artist document ids keyed by artist name.

## Advanced Views, Changes API, and Replicating Data


[fauxton-first-page]: https://github.com/cygni/cygni-competence-7-databases/blob/screenshots/couchdb/fuxton-first-page.PNG?raw=true "Fuxton First Page"
[fauxton-music-db]: fauxton-music-db.png "Fauxton 'music' database"
[couch-download]: http://couchdb.apache.org/#download 
[fauxton]: http://localhost:5984/_utils/
