# ~*~ encoding: utf-8 ~*~
require 'cgi'
require 'sinatra'
require 'pagoda'
require 'mustache/sinatra'


require 'pagoda/views/layout'

module Shwedagon
  class App < Sinatra::Base
    register Mustache::Sinatra
    dir = File.dirname(File.expand_path(__FILE__))
    set :public_folder, "#{dir}/public"
    set :static, true

    set :mustache, {
      # Tell mustache where the Views constant lives
      :namespace => Shwedagon,

      # Mustache templates live here
      :templates => "#{dir}/templates",

      # Tell mustache where the views are
      :views => "#{dir}/views"
    }

    get '/' do
      @drafts = ['Hello There', 'Another draft']
      @published = ['Testing here', 'Published new']
      mustache :home
    end
  end
end