$:.unshift File.join(File.dirname(__FILE__), *%w[lib])

require 'rubygems'
require 'pagoda/app'
require 'digest/md5'
require 'sidekiq/web'
require 'dotenv'

Dotenv.load

use Rack::ShowExceptions

puts "\n============================\n\n\n"
puts "Starting up Pagoda with #{ENV['JEKYLL_REPO']} as the remote repo"
puts "\n\n============================\n"

Shwedagon::App.set :repo_src, ENV['JEKYLL_REPO']
map ('/admin') { run Shwedagon::App.new }
map ('/sidekiq') { run Sidekiq::Web.new }