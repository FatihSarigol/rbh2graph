#Transfer all .species .og .alg files together with ALGs and OGs files to /var/lib/neo4j/import on your server and run the CypherCode file via cypher-shell as below (change the variables based on your server and Neo4J installation):
cypher-shell -u user -p password -d database -a neo4j://serverIP:port -f CypherCode
