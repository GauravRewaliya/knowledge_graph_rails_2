require "neo4j_ruby_driver"

config = {
  max_connection_pool_size: 100,
  max_connection_lifetime: 1.hour
}
auth = Neo4j::Driver::AuthTokens.basic(
  ENV.fetch("NEO4J_USERNAME", "neo4j"),
  ENV.fetch("NEO4J_PASSWORD", "password")
)
base_url = ENV.fetch("NEO4J_BASE_URL", "bolt://localhost:7687")
# Neo4jDriver = Neo4j::Driver::GraphDatabase.driver(base_url, auth, **config)
# if Neo4jDriver.verify_connectivity
#   puts "Graph DB Driver is connected to the database"
# else
#   puts "Graph DB Driver cannot connect to the database"
# end
