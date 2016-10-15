# CouchDB

## Installing CouchDB

### Docker

- `docker build -t couchdb .`
- `docker run -d --name couchdb-run -p 5984:15984 couchdb`

### Windows and OSX

 - Download and use installer [http://couchdb.apache.org/#download][couch-download]
 
### Verify installation
Open browser and go to: [localhost:5984/_utils][fauxton]
 
![alt text][fauxton-first-page]

## Exercises
### CRUD
### Views
### Etc


[fauxton-first-page]: ./img/fuxton-first-page.png "Fuxton First Page"
[couch-download]: http://couchdb.apache.org/#download 
[fauxton]: http://localhost:5984/_utils/