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
  end

  test "Basic listing for the example case" do
    get '/'

    assert_match /Pale Blue Dot/, last_response.body
    assert_match /Hello World/, last_response.body
  end

  test "Create a simple post" do
    create_post('Create new post test', 'Body content for new post')
    assert_equal last_response.status, 302


    get '/'
    assert_match /Create new post test/, last_response.body

    post_date  = (Time.now).strftime("%Y-%m-%d")
    get "/edit/#{post_date}-create-new-post-test.md"

    assert_equal last_response.status, 200
    assert_match /Body content for new post/, last_response.body
  end

  test "Delete a post" do
    create_post('Deletable post', 'Body content for new post')

    get '/'
    assert_match /Deletable post/, last_response.body

    get '/delete/deletable-post.md'
    assert_equal last_response.status, 302

    get '/edit/deletable-post.md'
    assert_equal 404, last_response.status
  end

  def app
    Shwedagon::App
  end

end