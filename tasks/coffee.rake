namespace :coffee do

  desc "Watch coffeescript and compile changes"
  task :watch do
    system "coffee --compile --watch lib/pagoda/public/js/*.coffee"
  end
end