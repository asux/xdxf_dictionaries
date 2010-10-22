 namespace :xdxf do
   desc "Import a XDXF file inside the database"
   task :import => :environment do
     fail "No FILEPATH given" unless ENV['FILEPATH']
     require 'xdxf_dictionaries'
     XDXF::Importer.import(ENV['FILEPATH'], {:verbose => true})
   end
 end
