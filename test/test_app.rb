# ~*~ encoding: utf-8 ~*~
require File.expand_path(File.join(File.dirname(__FILE__), "helper"))

context "Frontend" do
  include Rack::Test::Methods

  setup do
    @path = cloned_testpath("examples/sample-blog.git")
    Shwedagon::App.set :blog, @path
  end

  teardown do
    FileUtils.rm_rf(@path)
  end

  test "Basic listing for the example case" do
    get '/'

    assert_match /Pale Blue Dot/, last_response.body
    assert_match /Hello World/, last_response.body
  end

  test "Create a simple post" do
    post 'save-post', :method => 'put', :post => 
      { :title => 'Create new post test',
        :content => 'Body content for new post'}
    assert_equal last_response.status, 302


    get '/'
    assert_match /Create new post test/, last_response.body

    post_date  = (Time.now).strftime("%Y-%m-%d")
    get "/edit/#{post_date}-create-new-post-test.md"

    assert_equal last_response.status, 200
    assert_match /Body content for new post/, last_response.body
  end

  test "Delete a post" do
    post 'save-post', :method => 'put', :post => 
      { :title => 'Deletable post',
        :content => 'Body content for new post'}

    get '/'
    assert_match /Deletable post/, last_response.body

    get '/delete/deletable-post.md'
    assert_match 302, last_response.status

    get '/edit/create-new-post.md'
    assert_match 404, last_response.status
  end

  def app
    Shwedagon::App
  end

end