var neo4j = require('neo4j-driver').v1;

var driver = neo4j.driver("bolt://localhost", neo4j.auth.basic("neo4j", "abc123"));
var session = driver.session();
session
  .run( "match (p:Person) return p" )
  .then( function( result ) {
    console.log( result.records[0].get(0));
    session.close();
    driver.close();
  });