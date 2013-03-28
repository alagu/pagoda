# ~*~ encoding: utf-8 ~*~
require 'cgi'
require 'sinatra'
require 'pagoda'
require 'mustache/sinatra'
require "sinatra/reloader"
require 'jekyll'
require 'jekyll-mod'
require 'json'
require 'grit'

require 'pagoda/views/layout'

module Shwedagon
  class App < Sinatra::Base
    register Mustache::Sinatra
    register Sinatra::Reloader

    dir = File.dirname(File.expand_path(__FILE__))
    set :public_folder, "#{dir}/public"
    set :static, true
    cwd = Dir.pwd

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
      
      @title   = post.data['title']
      @content = post.content
      @name    = post.name


      mustache :edit
    end

    get '/new' do
      mustache :new
    end

    post '/save-post' do
      content_type 'text/plain'

      filename = params[:post][:name]
      config = Jekyll.configuration({'source' => settings.blog})
      site   = Jekyll::Site.new(config)
      post   = Jekyll::Post.new(site, site.source, '', filename)


      content  = post.data.to_yaml + "---\n"
      content += params[:post][:content]

      file = File.join(site.source, *%w[_posts], filename)
      if File.exists? file
        File.open(file, 'w') { |file| file.write(content)}
      end

      repo = Grit::Repo.new(settings.blog)
      Dir.chdir(settings.blog)

      repo.status.changed.keys.each do |file|
        repo.add file
      end

      data = repo.commit_index "Changed #{filename}"

       redirect '/edit/' + filename
    end

  end
end