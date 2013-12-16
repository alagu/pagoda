# ~*~ encoding: utf-8 ~*~
require 'cgi'
require 'sinatra'
require 'mustache/sinatra'
require "sinatra/reloader"
require 'jekyll'
require 'json'
require 'grit'
require 'stringex'
require 'yaml'
require 'sidekiq'

require 'pagoda/views/layout'
require 'pagoda/helper'
require 'pagoda/config'
require 'pagoda/jekyll_mod'
require 'workers/push_commit'


# Sinatra based frontend
module Shwedagon


  class App < Sinatra::Base
   
    before do
      @base_url = url('/', false).chomp('/')
      clone_repo()
    end

    def yaml_data(post_title)
      defaults = { 'title' => post_title,
        'layout' => 'post',
        'published' => false }

      defaults = defaults.merge(default_yaml())

      defaults
    end

    # Create a new post from scratch. Return filename
    # This would not commit the file.
    def create_new_post(params)      
      post_title = params['post']['title']
      post_date  = (Time.now).strftime("%Y-%m-%d")

      content    = yaml_data(post_title).to_yaml + "---\n" + params[:post][:content]
      post_file  = (post_date + " " + post_title).to_url + '.md'
      file       = File.join(jekyll_site.source, *%w[_posts], post_file)
      File.open(file, 'w') { |file| file.write(content)}
      post_file
    end


    # Merge existing yaml with post params
    def merge_config(yaml, params)
      if params['post'].has_key? 'yaml'
        params['post']['yaml'].each do |key, value|
          if value == 'true'
            yaml[key] = true
          elsif value == 'false'
            yaml[key] = false
          else
            yaml[key] = value
          end
        end
      end

      yaml
    end

    def write_post_contents(content, yaml, post_file)
      writeable_content  = yaml.to_yaml + "---\n" + content
      file_path          = post_path(post_file)

      if File.exists? file_path
        File.open(file_path, 'w') { |file| file.write(writeable_content)}
      end
    end

    # Update exiting post.
    def update_post(params)
      post_file   = params[:post][:name]
      post        = jekyll_post(post_file)
      yaml_config = merge_config(post.data, params)
      write_post_contents(params[:post][:content], yaml_config, post_file)

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
      post_file = params[:splat].first
      full_path = post_path(post_file)

      repo.remove([full_path])
      data = repo.commit_index "Deleted #{post_file}"
      push_to_origin(repo)
      
      redirect @base_url
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

      @data_array = []

      post.data.each do |key, value|
        @data_array << {'key' => key, 'value' => value}
      end

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

      if params[:method] == 'put'
        filename = create_new_post(params)        
        log_message = "Created #{filename}"
      else
        filename = update_post(params)
        log_message = "Changed #{filename}"
      end

      # Stage the file for commit
      repo.add File.join(jekyll_site.source, *%w[_posts], filename)

      data = repo.commit_index log_message
      push_to_origin(repo)

      if params[:ajax]
        {:status => 'OK'}.to_json
      else
        redirect @base_url + '/edit/' + filename
      end
    end

  end
end