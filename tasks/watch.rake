namespace :watch do

  desc "Watch coffeescript and compile changes"
  task :coffee do
    system "coffee --compile --watch lib/pagoda/public/js/*.coffee"
  end


  desc "Watch the styles and compile new changes"
  task :compass do
    system "compass watch ."
  end

  task :all do
    coffee_pid  = Process.spawn "coffee --compile --watch lib/pagoda/public/js/*.coffee"
    compass_pid = Process.spawn "compass watch ."

    [coffee_pid, compass_pid].each { |pid| Process.wait(pid) }
  end
end

task :watch => ["watch:all"]