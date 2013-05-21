require 'bundler'
require 'rubygems'
# Workaround for rake 10.0.4/Ruby 1.9.2p290 rdoc collision
# https://github.com/jimweirich/rake/issues/157
gem 'rdoc', ">= 2.4.2"
require 'rdoc/task'

Bundler::GemHelper.install_tasks

task :default => :install

gem_spec = eval(File.read("knife-reporting.gemspec"))

RDoc::Task.new do |rdoc|
  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "knife-reporting #{gem_spec.version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end

