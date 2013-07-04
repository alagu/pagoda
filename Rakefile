require 'rubygems'
require 'bundler'
require 'rake'

Bundler.setup

Dir["tasks/*.rake"].sort.each { |ext| load ext }

require 'rake/testtask'
Rake::TestTask.new(:test) do |test|
  test.libs << 'lib' << 'test'
  test.pattern = 'test/**/test_*.rb'
  test.verbose = true
end

task :default => :test