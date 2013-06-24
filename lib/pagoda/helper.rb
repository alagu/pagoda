# Helper functions for pagoda app
module Shwedagon
  class App < Sinatra::Base
    
    # Jekyll site instance
    def jekyll_site
      if not @site
        config  = Jekyll.configuration({'source' => settings.blog})
        @site   = Jekyll::Site.new(config)
        @site.read
      end

      @site
    end

    # Grit repo instance
    def repo
      @repo ||= Grit::Repo.new(settings.blog) 
      Dir.chdir(settings.blog)

      @repo
    end

    # Shortcut for checking whether the post exists
    def post_exists?(post_file)
	  File.exists? post_path(post_file) or File.exists? draft_path(post_file)
    end

    # Expanded post path of the post file
    def post_path(post_file)
      File.join(jekyll_site.source, *%w[_posts], post_file)
    end

    # Expanded draft path of the post file
    def draft_path(post_file)
      File.join(jekyll_site.source, *%w[_drafts], post_file)
    end

    def default_yaml
      defaults_file = File.join(jekyll_site.source, '_default.yml')
      defaults  = {}
      if File.exists? defaults_file
        defaults = YAML::load(File.read(defaults_file))
      end

      defaults
    end

    # Jekyll instance of post file
    def jekyll_post(post_file)
	  if File.exists? post_path(post_file)
		  Jekyll::Post.new(jekyll_site, jekyll_site.source, '', post_file)
      else
		  Jekyll::Draft.new(jekyll_site, jekyll_site.source, '', post_file)
      end
    end

    # Gives out a sorted list of post template data
    # for a post or draft
    def posts_template_data(post_items)
      if post_items.nil?
        return []
      end

      template_data = post_items.map do |post|
        {
          :title    => post.data['title'],
          :filename => post.name,
          :date     => post.date
        }
      end

      template_data.sort! { |x,y| y[:date] <=> x[:date] }

      template_data
    end
  end
end
