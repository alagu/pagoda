require 'sshkey'
require 'highline/import'
require 'digest/md5'
require 'net/http'
require 'net/https'
require 'json'

def heroku_auth
  config_raw = File.read("#{Dir.home}/.netrc")
  lines = config_raw.split "\n"

  for line in lines
    if not ((line.index "machine api.heroku.com").nil?)
      record = 1
      next
    end

    if record > 0 and record < 3
      record = record + 1

      case record
      when 2
        user   = line.gsub(" login", "").strip
      when 3 
        passwd = line.gsub(" password", "").strip
      end
    end
  end

  app_name = `git remote -v | grep heroku | head -1 | cut -d " " -f1 | cut -d " " -f2 | cut -d ":" -f2 | cut -d "." -f1`
  app_name.strip!

  {:user => user, :pass => passwd, :app =>app_name}
end

def get_config(heroku)
  http = Net::HTTP.new("api.heroku.com",443)
  headers = { "Accept" => "application/vnd.heroku+json; version=3"}
  req  = Net::HTTP::Get.new("/apps/#{heroku_auth[:app]}/config-vars", headers)
  http.use_ssl = true
  req.basic_auth heroku[:user], heroku[:pass]
  response = http.request(req)
  return JSON.parse(response.body)
end

def set_config(heroku, key, value)
  http         = Net::HTTP.new("api.heroku.com",443)
  headers      = { "Accept" => "application/vnd.heroku+json; version=3", "Content-Type" => "application/json"}
  request      = Net::HTTP::Patch.new("/apps/#{heroku_auth[:app]}/config-vars", headers)
  http.use_ssl = true
  
  request.basic_auth heroku[:user], heroku[:pass]

  request.body = {key => value}.to_json
  response = http.request(request)
  return JSON.parse(response.body)
end


task "heroku" do
  puts "Configuring Heroku for you"
  new_conf = {}
  new_conf['JEKYLL_REPO'] = ask "Enter your repository url (e.g git@bitbucket.org:alagu/private-blog.git): "
  new_conf['LOGIN_USER']  = ask "Pick a Username: "
  new_conf['LOGIN_PASS']  = Digest::MD5.hexdigest(ask("Enter a password:  ") { |q| q.echo = "*" })  

  ssh = SSHKey.generate(:comment => new_conf['LOGIN_USER'])
  new_conf['SSH_PRIVATE_KEY'] = ssh.private_key
  public_key  = ssh.ssh_public_key
  File.open("#{Dir.home}/.ssh/pagoda-key.pub", 'w+') { |f| f.write public_key }
  
  heroku_auth_data = heroku_auth()
  existing_config  = get_config(heroku_auth_data)

  new_conf.each do |key,value|
    if not existing_config.has_key? key
      set_config(heroku_auth_data, key, new_conf[key])      
    else
      puts "#{key} is already set"
    end
  end


  puts "Heroku configuration Done. "

  puts "Copy this ssh public key to github or bitbucket or your git remote (also saved in ~/.ssh/pagoda-key.pub)" 
  puts 
  puts public_key
  puts 
  puts "Visit http://#{heroku_auth_data[:app]}.herokuapp.com/ and login with the above given Username & Password"
end