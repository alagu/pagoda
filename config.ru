$:.unshift File.join(File.dirname(__FILE__), *%w[lib])

require 'rubygems'

require 'pagoda/app'

use Rack::ShowExceptions

Shwedagon::App.set :repo_src, ENV['JEKYLL_REPO']

map ('/admin') { run Shwedagon::App.new }