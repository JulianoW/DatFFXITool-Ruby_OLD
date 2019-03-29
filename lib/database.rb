require 'YAML'
require 'mysql2'

config = YAML::load_file("lib/config/database.yaml")
client = Mysql2::Client.new(:host => config["host"], :username => config["username"], 
:password => config["password"])

# init db
client.query("CREATE DATABASE IF NOT EXISTS FFXIDATS")

