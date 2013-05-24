$:.unshift File.join(File.dirname(__FILE__), *%w[lib])

require 'rubygems'

require 'pagoda/app'

use Rack::ShowExceptions

Shwedagon::App.set :blog, ENV['blog']
run Shwedagon::App.new
