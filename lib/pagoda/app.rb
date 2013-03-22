# ~*~ encoding: utf-8 ~*~
require 'cgi'
require 'sinatra'
require 'pagoda'
require 'mustache/sinatra'
require 'jekyll'
require 'jekyll-mod'

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
      config = Jekyll.configuration({'source' => '../blog'})
      site   = Jekyll::Site.new(config)
      site.read

      @drafts = (site.read_drafts.map { |p| p.data['title']}).reverse!
      @published = (site.posts.map { |p| p.data['title'] }).reverse!


    #  ['Testing here', 'Published new']
      mustache :home
    end
  end
end