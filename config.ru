$:.unshift File.join(File.dirname(__FILE__), *%w[lib])

require 'rubygems'
require 'pagoda/app'
require 'digest/md5'

use Rack::ShowExceptions

if ENV.has_key? 'HTTP_MESSAGE'
  message = ENV['HTTP_MESSAGE']
else
  message = "Private Blog"
end

use Rack::Auth::Basic, message do |username, password|
  md5_pass = Digest::MD5.hexdigest(password)
  [username, md5_pass] == [ENV['LOGIN_USER'], ENV['LOGIN_PASS']]
end

Shwedagon::App.set :repo_src, ENV['JEKYLL_REPO']

map ('/admin') { run Shwedagon::App.new }