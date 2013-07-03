require 'rubygems'
require 'bundler'
require 'rake'
require 'sshkey'
require 'highline/import'
require 'digest/md5'

Bundler.setup

Dir["tasks/*.rake"].sort.each { |ext| load ext }

require 'rake/testtask'
Rake::TestTask.new(:test) do |test|
  test.libs << 'lib' << 'test'
  test.pattern = 'test/**/test_*.rb'
  test.verbose = true
end

task :default => :test

task "heroku" do
  puts "Configuring Heroku for you"
  repo   = ask "Enter your repository url (e.g git@bitbucket.org:alagu/private-blog.git): "
  email  = ask "Your email id: "
  passwd = Digest::MD5.hexdigest(ask("Enter a password:  ") { |q| q.echo = "*" })  

  ssh = SSHKey.generate(:comment => email)
  private_key = ssh.private_key
  public_key  = ssh.ssh_public_key
  
  system('heroku config:add SSH_PRIVATE_KEY="' + private_key + '"')
  system('heroku config:add LOGIN_USER="' + email + '"')
  system('heroku config:add LOGIN_PASS="' + passwd + '"')
  system('heroku config:add JEKYLL_REPO="' + repo + '"')
  puts public_key
end