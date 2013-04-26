# ~*~ encoding: utf-8 ~*~
require File.expand_path(File.join(File.dirname(__FILE__), "helper"))

context "Frontend" do
  include Rack::Test::Methods

  setup do
    @path = cloned_testpath("examples/sample-blog.git")
    Shwedagon::App.set :blog, @path
  end

  teardown do
    Dir.chdir("/")
    FileUtils.rm_rf(@path)
  end


  def create_post(title, content)
    post 'save-post', :method => 'put', :post => 
      { :title => title ,
        :content => content}

    post_date = (Time.now).strftime("%Y-%m-%d")
    (post_date + " " + title).to_url + '.md'
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

  def app
    Shwedagon::App
  end

end