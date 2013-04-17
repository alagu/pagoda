# ~*~ encoding: utf-8 ~*~
require 'cgi'
require 'sinatra'
require 'mustache/sinatra'
require "sinatra/reloader"
require 'jekyll'
require 'jekyll-mod'
require 'json'
require 'grit'
require 'stringex'

require 'pagoda/views/layout'
require 'pagoda/helper'

# Sinatra based frontend
module Shwedagon
  class App < Sinatra::Base
    register Mustache::Sinatra
    register Sinatra::Reloader


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

    # Create a new post from scratch. Return filename
    # This would not commit the file.
    def create_new_post(params)      
      post_title = params['post']['title']
      post_date  = (Time.now).strftime("%Y-%m-%d")
      yaml_data  = { 'title' => post_title,
        'layout' => 'post',
        'published' => false }

      content    = yaml_data.to_yaml + "---\n" + params[:post][:content]
      post_file  = (post_date + " " + post_title).to_url + '.md'
      file       = File.join(jekyll_site.source, *%w[_posts], post_file)
      File.open(file, 'w') { |file| file.write(content)}
      post_file
    end

    # Update exiting post.
    def update_post(params)
      post_file  = params[:post][:name]
      post      = jekyll_post(post_file)

      post.data['published'] = ! (params[:post].has_key? 'draft')
      post.data['title']     = params[:post][:title]

      content  = post.data.to_yaml + "---\n" + params[:post][:content]
      file     = post_path(post_file)

      if File.exists? file
        File.open(file, 'w') { |file| file.write(content)}
      end

      post_file
    end

    # Index of drafts and published posts
    get '/' do
      @drafts    = posts_template_data(jekyll_site.read_drafts)
      @published = posts_template_data(jekyll_site.posts)

      mustache :home
    end


    #Delete any post. Ideally should be post. For convenience, it is get. 
    get '/delete/*' do
      filename = params[:splat].first
      full_file  = File.join(jekyll_site.source, *%w[_posts], filename)

      repo.remove([full_file])
      data = repo.commit_index "Deleted #{filename}"
      redirect '/'
    end

    # Edit any post
    get '/edit/*' do
      post_file = params[:splat].first

      if not post_exists?(post_file)
        halt(404)
      end

      post     = jekyll_post(post_file) 
      @title   = post.data['title']
      @content = post.content
      @name    = post.name
      if post.data['published'] == false
        @draft = true
      end


      mustache :edit
    end

    get '/new' do
      @ptitle = params['ptitle']
      mustache :new_post
    end

    get '/settings' do
      mustache :settings
    end

    get '/settings/pull' do
      
      data = repo.git.pull({}, "origin", "master")
      return data + " done"
    end

    get '/settings/push' do
      data = repo.git.push
      return data + " done"
    end

    post '/save-post' do
      config = Jekyll.configuration({'source' => settings.blog})
      site   = Jekyll::Site.new(config)

      if params[:method] == 'put'
        filename = create_new_post(params)
      else
        filename = update_post(params)
      end

      # Stage the file for commit
      repo.add File.join(jekyll_site.source, *%w[_posts], filename)

      data = repo.commit_index "Changed #{filename}"

      redirect '/edit/' + filename
    end

  end
end