require "bundler/gem_tasks"
require 'rspec/core/rake_task'
require 'rdoc/task'

task :default => [:spec]
RSpec::Core::RakeTask.new do |t|
    t.verbose = true
end

Rake::RDocTask.new do |rd|
  rd.main = "README.md"
  rd.rdoc_files.include("README.md", "lib/**/*.rb")
end