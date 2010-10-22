LIB_ROOT = File.dirname(__FILE__)

require File.join(LIB_ROOT, 'xdxf', 'models', 'model.rb')
require File.join(LIB_ROOT, 'xdxf', 'models', 'dictionary.rb')
require File.join(LIB_ROOT, 'xdxf', 'models', 'article.rb')
require File.join(LIB_ROOT, 'xdxf', 'models', 'article_key.rb')
require File.join(LIB_ROOT, 'xdxf', 'models', 'article_key_article_join.rb')

require File.join(LIB_ROOT, 'xdxf', 'importer.rb')
require File.join(LIB_ROOT, 'migration.rb')

puts "Loaded xdxf_dictionaries"
