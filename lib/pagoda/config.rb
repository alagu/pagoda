# Configuration for the pagoda app
module Shwedagon
  class App < Sinatra::Base

    register Mustache::Sinatra
    register Sinatra::Reloader


    dir = File.dirname(File.expand_path(__FILE__))
    set :public_folder, "#{dir}/public"
    set :static, true

    set :mustache, {
      # Tell mustache where the Views constant lives
      :namespace => Shwedagon,

      # Mustache templates live here
      :templates => "#{dir}/templates",

      # Tell mustache where the views are
      :views => "#{dir}/views"
    }
  end
end