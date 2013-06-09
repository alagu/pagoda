require 'rake'

# Publishing gem:
# 
# $ bundle exec rake gem:publish 

namespace :gem do

  task :cleanup do
    puts "Cleaning up old gems"
    system "rm pagoda-jekyll*gem"
  end

  task :create do
    puts "Building new gem"
    system "gem build pagoda.gemspec"
  end

  task :publish => [:cleanup, :create] do
    gem_zip = `ls pagoda-jekyll*gem`.gsub("\n", "")
    command = "gem push #{gem_zip}"
    system command
  end
end