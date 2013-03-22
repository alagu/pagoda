# ~*~ encoding: utf-8 ~*~
require 'cgi'
require 'sinatra'
require 'pagoda'
require 'mustache/sinatra'

module Shwedagon
  class App < Sinatra::Base
    register Mustache::Sinatra

    get '/' do
      "Hello"
    end
  end
end