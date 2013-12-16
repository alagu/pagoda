require 'rubygems'

require 'simplecov'
require 'coveralls'
SimpleCov.start
Coveralls.wear!
SimpleCov.formatter = Coveralls::SimpleCov::Formatter

require 'rack/test'
require 'test/unit'
require 'shoulda'
require 'mocha/setup'
require 'fileutils'
require 'minitest/reporters'
require 'jekyll'
require 'grit'
require 'pp'

require 'sidekiq'
require 'sidekiq/testing'
Sidekiq::Testing.fake!

require 'pagoda/app'

ENV['RACK_ENV'] = 'test'

# Make sure we're in the test dir, the tests expect that to be the current
# directory.
TEST_DIR = File.join(File.dirname(__FILE__), *%w[.])

def testpath(path)
  File.join(TEST_DIR, path)
end

def tmp_path(path = "")
  root_path = File.dirname(File.dirname(File.expand_path(__FILE__)))
  File.join root_path, "tmp", path
end

def cloned_path
  tmp_path("repo")
end

# Copy the remote to another place to be cloned
def copied_remote(path)
  remote = File.expand_path(testpath(path))
  remote_copied = tmp_path("remote_copied")

  FileUtils.cp_r remote, remote_copied

  remote_copied
end

# Jekyll instance of post file
def jekyll_post_object(path, file)

  original_stdout = $stdout
  $stdout = File.new('/tmp/null.txt', 'w')

  config = Jekyll.configuration({'source' => path})
  site   = Jekyll::Site.new(config)
  
  $stdout = original_stdout

  Jekyll::Post.new(site, site.source, '', file)

end

def create_post(title, content)
  repo = Grit::Repo.new @path

  post 'save-post', :method => 'put', :post => 
    { :title => title ,
      :content => content}



  post_date = (Time.now).strftime("%Y-%m-%d")
  (post_date + " " + title).to_url + '.md'
end

def commit_details
  { :message => "Did something at #{Time.now}",
    :name    => "Alagu",
    :email   => "alagu@alagu.net" }
end

# test/spec/mini 3
# http://gist.github.com/25455
# chris@ozmm.org
# file:lib/test/spec/mini.rb
def context(*args, &block)
  return super unless (name = args.first) && block
  require 'test/unit'
  klass = Class.new(defined?(ActiveSupport::TestCase) ? ActiveSupport::TestCase : Test::Unit::TestCase) do
    def self.test(name, &block)
      define_method("test_#{name.gsub(/\W/,'_')}", &block) if block
    end
    def self.xtest(*args) end
    def self.setup(&block) define_method(:setup, &block) end
    def self.teardown(&block) define_method(:teardown, &block) end
  end
  (class << klass; self end).send(:define_method, :name) { name.gsub(/\W/,'_') }
  $contexts << klass
  klass.class_eval &block
end
$contexts = []
