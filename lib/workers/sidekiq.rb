
$:.unshift File.join(File.dirname(__FILE__), *%w[.. lib])

require 'rubygems'
require 'pagoda/app'
require 'workers/push_commit'
require 'dotenv'

Dotenv.load