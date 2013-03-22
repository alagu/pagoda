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
      config = Jekyll.configuration({'source' => settings.blog})
      site   = Jekyll::Site.new(config)
      site.read

      @drafts = site.read_drafts.map do |post|
        {
          :title => post.data['title'],
          :filename => post.name
        }
      end

      @drafts.reverse!

      @published = site.posts.map do |post|
        {
          :title => post.data['title'],
          :filename => post.name
        }
      end

      @published.reverse!
    
      mustache :home
    end

    get '/edit/*' do
      file =  params[:splat].first

      config = Jekyll.configuration({'source' => settings.blog})
      site   = Jekyll::Site.new(config)
      post   = Jekyll::Post.new(site, site.source, '', file)
      
      @title = post.data['title']
      @content = post.content


      mustache :edit
    end

  end
end