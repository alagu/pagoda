# ~*~ encoding: utf-8 ~*~
require File.expand_path(File.join(File.dirname(__FILE__), "helper"))

context "Frontend" do
  include Rack::Test::Methods

  setup do
    @path = cloned_testpath("examples/sample-blog.git")
    config  = Jekyll.configuration({'source' => @path})
    @site   = Jekyll::Site.new(config)
    Shwedagon::App.set :blog, @path
  end

  teardown do
    FileUtils.rm_rf(@path)
  end

  test "Create a simple post" do
    post 'save-post', :method => 'put', :post => 
      { :title => 'Create new post test',
        :content => 'Body content for new post'}

    get '/'

    assert_match /Create new post test/, last_response.body

    get '/edit/create-new-post.md'
    assert_match /Body content for new post/, last_response.body
  end


  def app
    Shwedagon::App
  end

end