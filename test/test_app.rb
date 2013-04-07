# ~*~ encoding: utf-8 ~*~
require File.expand_path(File.join(File.dirname(__FILE__), "helper"))

context "Frontend" do
  include Rack::Test::Methods

  setup do
  end

  teardown do
  end

  test "dummy test" do
    sample_variable = "Hello"

    assert_equal sample_variable, "Hello"
  end

end