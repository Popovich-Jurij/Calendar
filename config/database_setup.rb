require 'active_record'
require 'sinatra'
$config = YAML::load_file('config/database.yml')

environment = 'development'

ActiveRecord::Base.establish_connection($config[environment])
