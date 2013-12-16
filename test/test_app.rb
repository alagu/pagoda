# ~*~ encoding: utf-8 ~*~
require File.expand_path(File.join(File.dirname(__FILE__), "helper"))

context "Frontend" do
  include Rack::Test::Methods

  setup do
    @remote_path =  copied_remote("examples/sample-blog.git")
    @path        =  cloned_path()
    Shwedagon::App.set :repo_src, @remote_path 
    get '/'
  end

  teardown do
    Dir.chdir("/")
    FileUtils.rm_rf @remote_path
    FileUtils.rm_rf @path
  end


  test "Basic listing for the example case" do
    get '/'

    assert_match /Pale Blue Dot/, last_response.body
    assert_match /Hello World/, last_response.body
  end

  test "Create a simple post" do
    post_file = create_post('Create new post test', 'Body content for new post')
    assert_equal last_response.status, 302

    # Check whether it has been committed
    repo = Grit::Repo.new @path
    assert_equal repo.log.first.message, "Created #{post_file}"

    get "/"
    assert_match /Create new post test/, last_response.body

    get "/edit/#{post_file}"

    assert_equal last_response.status, 200
    assert_match /Body content for new post/, last_response.body
  end

  test "Create a post with default yaml" do
    yaml_content = <<YAML
youtube: enter_youtube_url
picasa: enter_picasa_url
YAML

    default_yaml = File.join @path, "_default.yml"

    File.open(default_yaml, 'w') { |file| file.write(yaml_content) }

    assert_equal File.exists?(default_yaml), true

    post_file = create_post('Create new post test', 'Body content for new post')
    post_object = jekyll_post_object(@path, post_file)
    assert_equal post_object.data['youtube'], 'enter_youtube_url'
    assert_equal post_object.data['picasa'], 'enter_picasa_url'
  end

  test "Edit a post" do
    post_file = create_post('Editable post', 'Text 1')
    
    # Check whether it has been committed
    repo = Grit::Repo.new @path
    assert_equal repo.log.first.message, "Created #{post_file}"

    
    get "/edit/#{post_file}"
    assert_equal last_response.status, 200    
    assert_match /Text 1/, last_response.body
    assert_no_match /Text 1 and Text 2/, last_response.body

    post "/save-post", :post => 
      { :title   => 'Editable post',
        :content => 'Text 1 and Text 2',
        :name    => post_file}

    assert_equal last_response.status, 302    
    
    # Check repo for edit
    assert_equal repo.log.first.message, "Changed #{post_file}"

    get "/edit/#{post_file}"
    assert_match /Text 1 and Text 2/, last_response.body
  end

  test "Edit post ajax" do
    post_file = create_post('Editable post', 'Text 1')

    post "/save-post", 
      :post => 
        { :title   => 'Editable post',
          :content => 'Text 1 and Text 2',
          :name    => post_file},
      :ajax => true

    assert_equal last_response.status, 200
    assert_match /"status":"OK"/, last_response.body

    get "/edit/#{post_file}"
    assert_match /Text 1 and Text 2/, last_response.body
  end

  test "Edit post with yaml" do
    post_file = create_post('Editable post', 'Text 1')
    youtube_url = 'http://www.youtube.com/watch?v=p86BPM1GV8M'
    post "/save-post",
      :post =>
        { 
          :title   => 'Editable post',
          :content => 'Text 1 and Text 2',
          :name    => post_file,
          :yaml    => { :youtube => youtube_url }
        },
      :ajax => true

    assert_equal last_response.status, 200
    assert_match /"status":"OK"/, last_response.body

    post_object = jekyll_post_object(@path, post_file)
    assert_equal post_object.data['youtube'], youtube_url
  end

  test "Draft and Undraft" do
    post_file   = create_post('Draftable post', 'Text 1')

    # Verify whether it is in draft
    post_object = jekyll_post_object(@path, post_file)
    assert_equal post_object.data['published'], false
    
    post "/save-post", 
         :post => 
           { :title   => 'Draftable post',
             :content => 'Text 1',
             :name    => post_file,
             :yaml    => { :published => true }
           }

    # Verify whether it is published
    post_object = jekyll_post_object(@path, post_file)
    assert_equal post_object.data['published'], true

    # Make it draft again.
    post "/save-post", 
         :post => 
           { :title   => 'Draftable post',
             :content => 'Text 1',
             :name    => post_file,
             :yaml    => { :published => false }
           }

    post_object = jekyll_post_object(@path, post_file)
    assert_equal post_object.data['published'], false

  end


  test "Delete a post" do
    post_file = create_post('Deletable post', 'Body content for new post')

    get "/edit/#{post_file}"
    assert_equal last_response.status, 200


    get "/delete/#{post_file}"
    assert_equal last_response.status, 302

    # Check whether it has been deleted
    repo = Grit::Repo.new @path
    assert_equal repo.log.first.message, "Deleted #{post_file}"


    get "/edit/#{post_file}"
    assert_equal last_response.status, 404
  end

  test "Empty blog without posts" do

    Dir["#{@path}/_posts/*"].each do |post|
      post_file =  File.basename(post)
      get "/delete/#{post_file}"
    end 

    get "/"
    assert_equal last_response.status, 200
  end

  test "Check whether the push has gone to the remote" do
    post_file = create_post('Create new post test', 'Body content for new post')    

    repo = Grit::Repo.new @path
    logs = repo.git.log({}, "origin/master..master")

    assert_equal logs.length, 0
  
  end

  test "Basic Commits via Queues" do
    get '/'

    ENV["PUSH_VIA_QUEUE"] = "true"

    post_file = create_post('Create new post test', 'Body content for new post')

    ENV.delete "PUSH_VIA_QUEUE"

    assert_equal last_response.status, 302


    # Check whether it has been committed
    repo = Grit::Repo.new @path
    assert_equal repo.log.first.message, "Created #{post_file}"


    assert_equal 1, PushCommitWorker.jobs.size
    PushCommitWorker.drain

    logs = repo.git.log({}, "origin/master..master")
    assert_equal logs.length, 0
  end


  def app
    Shwedagon::App
  end

end