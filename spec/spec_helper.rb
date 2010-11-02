begin
  require File.dirname(__FILE__) + '/../../../../spec/spec_helper'
rescue LoadError
  puts "You need to install rspec in your base app"
  exit
end

plugin_spec_dir = File.dirname(__FILE__)
ActiveRecord::Base.logger = Logger.new(File.join(plugin_spec_dir, "debug.log"))

databases_yml = File.join(plugin_spec_dir, "db", "database.yml")
if File.file?(databases_yml)
  databases = YAML::load(File.read(databases_yml))
  ActiveRecord::Base.establish_connection(databases[ENV["DB"] || "sqlite3"])
end

schema_rb = File.join(plugin_spec_dir, "db", "schema.rb")
load(schema_rb) if File.file?(schema_rb)

require File.join(plugin_spec_dir, '../lib', 'xdxf_spec_helper')
