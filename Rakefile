require 'rake'
require 'rake/testtask'
require 'rake/rdoctask'
require 'spec/rake/spectask'

desc 'Default: run specs.'
task :default => :spec

desc 'Run the specs'
Spec::Rake::SpecTask.new(:spec) do |t|
  t.spec_opts = ['--colour --format progress --loadby mtime']
  t.spec_files = FileList['spec/**/*_spec.rb']
end

desc 'Generate documentation for the xdxf_dictionaries plugin.'
Rake::RDocTask.new(:rdoc) do |rdoc|
  rdoc.rdoc_dir = 'rdoc'
  rdoc.title    = 'XDXFDictionaries'
  rdoc.options << '--line-numbers' << '--inline-source'
  rdoc.rdoc_files.include('README')
  rdoc.rdoc_files.include('lib/**/*.rb')
end

begin
  require 'yard'
  YARD::Rake::YardocTask.new do |t|
    t.files   += ['README.rdoc', 'lib/**/*.rb']
    t.options += ['--private', '--protected']
  end
rescue LoadError => e
  puts "# Gem 'yard' not found"
end
