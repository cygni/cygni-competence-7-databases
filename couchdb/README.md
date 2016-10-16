# CouchDB

## Before we start
Before we start, please make sure you are able to run CouchDB 2.0 on your machine. Instructions on how to run or install CouchDB on different platform follows.

### Docker
This repository comes with a Dockerfile that allows you to download and run CouchDB inside a Docker container.

- `docker build -t couchdb .`
- `docker run -d --name couchdb-run -p 5984:15984 couchdb`

### Windows and OSX
If you do not have Docker installed or if you prefer to install CouchDB locally on your machine there are installers available for Windows and OSX. Both of them should ultimately start CouchDB as a service.

 - Download and use installer [http://couchdb.apache.org/#download][couch-download]
 
### Verify
To verify that your database is up and running at port 5984, go to [localhost:5984/_utils][fauxton]. This opens 'Fauxton', the web interface that comes with CouchDB.

- Open browser and go to: [localhost:5984/_utils][fauxton]
 
![alt text][fauxton-first-page]

## CRUD with Fauxton and cURL
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


### Views
### Etc


[fauxton-first-page]: https://github.com/cygni/cygni-competence-7-databases/blob/screenshots/couchdb/fuxton-first-page.PNG?raw=true "Fuxton First Page"
[fauxton-music-db]: fauxton-music-db.png "Fauxton 'music' database"
[couch-download]: http://couchdb.apache.org/#download 
[fauxton]: http://localhost:5984/_utils/