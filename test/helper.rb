require 'rubygems'
require 'rack/test'
require 'test/unit'
require 'shoulda'
require 'mocha/setup'
require 'fileutils'
require 'minitest/reporters'
require 'jekyll'
require 'grit'

require 'pagoda/app'

ENV['RACK_ENV'] = 'test'

# Make sure we're in the test dir, the tests expect that to be the current
# directory.
TEST_DIR = File.join(File.dirname(__FILE__), *%w[.])

def testpath(path)
  File.join(TEST_DIR, path)
end

def cloned_testpath(path)
  repo   = File.expand_path(testpath(path))
  path   = File.dirname(repo)
  cloned = File.join(path, self.class.name)
  FileUtils.rm_rf(cloned)
  Dir.chdir("/")
  Dir.chdir("/") do
    %x{git clone #{repo} #{cloned}}
    %x{git config --global user.email "alagu@alagu.net"}
    %x{git config --global user.name "Alagu"}
  end
  cloned
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
