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
require 'stringex'

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

    post '/new' do
      @post_title = params['new_post_title']
      mustache :new_post
    end

    post '/create-post' do
    end

    post '/save-post' do
      config = Jekyll.configuration({'source' => settings.blog})
      site   = Jekyll::Site.new(config)

      if params[:method] == 'put'
        post_title = params['post']['title']
        post_date  = (Time.now).strftime("%Y-%M-%d")
        yaml_data  = {'title' => post_title, 'layout' => 'post', 'published' => 'false'}
        content    = yaml_data.to_yaml + "---\n"
        content   += params[:post][:content]
        filename   = (post_date + " " + post_title).to_url + '.md'
        file       = File.join(site.source, *%w[_posts], filename)
        File.open(file, 'w') { |file| file.write(content)}
      else
        filename  = params[:post][:name]
        post   = Jekyll::Post.new(site, site.source, '', filename)
        content  = post.data.to_yaml + "---\n"
        content += params[:post][:content]

        file = File.join(site.source, *%w[_posts], filename)
        if File.exists? file
          File.open(file, 'w') { |file| file.write(content)}
        end
      end

      repo = Grit::Repo.new(settings.blog)

      # Git add works only when you do it from that path.
      Dir.chdir(settings.blog)

      repo.status.changed.keys.each do |file|
        repo.add file
      end

      if params[:method] == 'put'
        puts "Adding new file - #{filename}"
        repo.add File.join(site.source, *%w[_posts], filename)
      end

      data = repo.commit_index "Changed #{filename}"

      redirect '/edit/' + filename
    end

  end
end