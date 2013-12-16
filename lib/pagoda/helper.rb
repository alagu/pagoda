# Helper functions for pagoda app
module Shwedagon
  class App < Sinatra::Base
    
    # Jekyll site instance
    def jekyll_site
      if not @site
        # Supress stdout
        original_stdout = $stdout
        $stdout = File.new('/tmp/null.txt', 'w')

        config  = Jekyll.configuration({'source' => cloned_repo_path})
        @site   = Jekyll::Site.new(config)
        @site.read

        $stdout = original_stdout
      end

      @site
    end

    def git_opts
      {:raise=>true, :timeout=>false, :chdir => cloned_repo_path}
    end

    def app_base
      File.dirname(File.dirname(File.dirname(__FILE__)))
    end

    def push_to_origin(repo)
      if ENV['PUSH_VIA_QUEUE']
        PushCommitWorker.perform_async
      else
        repo.git.push(git_opts, ["origin"])
      end
    end

    def cloned_repo_path
      "#{app_base}/tmp/repo"
    end

    def clone_repo
      set_ssh_access()

      if not File.directory? cloned_repo_path
        grit = Grit::Git.new(cloned_repo_path)
        grit.clone({:quiet => false, :verbose => true, :progress => true}, settings.repo_src, cloned_repo_path)
      end
    end

    # Grit repo instance
    def repo
      @repo ||= Grit::Repo.new(cloned_repo_path) 
      Dir.chdir(cloned_repo_path)

      @repo
    end

    # Shortcut for checking whether the post exists
    def post_exists?(post_file)
      File.exists? post_path(post_file)
    end

    # Expanded post path of the post file
    def post_path(post_file)
      File.join(jekyll_site.source, *%w[_posts], post_file)
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
      Jekyll::Post.new(jekyll_site, jekyll_site.source, '', post_file)
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

    def set_ssh_access

      base = ENV['HOME']

      if ENV.has_key? 'SSH_PRIVATE_KEY' and 
        (not File.exists? "#{base}/.ssh/id_rsa") and
        ENV['RACK_ENV'] == 'production'

        FileUtils.mkdir_p "#{base}/.ssh/"
        f = File.new "#{base}/.ssh/id_rsa", 'w+'
        f.write ENV['SSH_PRIVATE_KEY']
        f.chmod(0600)
        f.close
        FileUtils.chmod 0700, "#{base}/.ssh"

        ssh_config = <<CONF
StrictHostKeyChecking no
UserKnownHostsFile /dev/null
CONF
        File.open("#{base}/.ssh/config", 'w+') { |f| f.write ssh_config }
      end

      if not File.exists? "#{base}/.gitconfig"
        git_config = <<CONF
[user]
  name = Pagoda Admin
  email = alagu@alagu.net
CONF
        File.open("#{base}/.gitconfig", 'w+') { |f| f.write git_config }
      end
    end
  end
end