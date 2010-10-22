 namespace :xdxf do
   desc "Import a XDXF file inside the database"
   task :import => :environment do
     raise "No FILEPATH given" unless ENV['FILEPATH']
     require 'xdxf_dictionaries'
     filename = File.expand_path(ENV['FILEPATH'])
     raise "File `#{filename}` not exists" unless File.file? filename
     XDXF::Importer.import(File.open(filename, 'r'), {:verbose => true})
   end
 end
