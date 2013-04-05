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

    def jekyll_site
      if not @site
        config = Jekyll.configuration({'source' => settings.blog})
        @site   = Jekyll::Site.new(config)
        @site.read
      end

      @site
    end

    def repo
      if not @repo
        @repo = Grit::Repo.new(settings.blog) 
      end
      Dir.chdir(settings.blog)

      @repo
    end

    # Index of drafts and published posts
    get '/' do
      @drafts = jekyll_site.read_drafts.map do |post|
        {
          :title => post.data['title'],
          :filename => post.name,
          :date     => post.date
        }
      end

      @drafts.sort! { |x,y| y[:date] <=> x[:date] }

      @published = jekyll_site.posts.map do |post|
        {
          :title => post.data['title'],
          :filename => post.name,
          :date  => post.date
        }
      end

      @published.sort! { |x,y| y[:date] <=> x[:date] }
    
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
      file =  params[:splat].first

      post   = Jekyll::Post.new(jekyll_site, jekyll_site.source, '', file)
      
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

    # Create a new post from scratch. Return filename
    # This would not commit the file.
    def create_new_post(params)      
      post_title = params['post']['title']
      post_date  = (Time.now).strftime("%Y-%m-%d")
      yaml_data  = { 'title' => post_title,
        'layout' => 'post',
        'published' => false }

      content    = yaml_data.to_yaml + "---\n"
      content   += params[:post][:content]
      filename   = (post_date + " " + post_title).to_url + '.md'
      file       = File.join(jekyll_site.source, *%w[_posts], filename)
      File.open(file, 'w') { |file| file.write(content)}
      filename
    end

    # Update exiting post.
    def update_post(params)
      

      filename  = params[:post][:name]
      post   = Jekyll::Post.new(jekyll_site, jekyll_site.source, '', filename)

      if not (params[:post].has_key? 'draft' and params[:post]['draft'] == "on")
        post.data['published'] = true
      else
        post.data['published'] = false
      end

      post.data['title'] = params[:post][:title]

      content  = post.data.to_yaml + "---\n"
      content += params[:post][:content]

      file = File.join(jekyll_site.source, *%w[_posts], filename)
      if File.exists? file
        File.open(file, 'w') { |file| file.write(content)}
      end

      filename
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