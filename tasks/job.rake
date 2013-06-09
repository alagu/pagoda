require 'rake'
namespace :job do
  task :watch do
    coffee_pid  = Process.spawn "coffee --compile --watch lib/pagoda/public/js/*.coffee"
    compass_pid = Process.spawn "compass watch ."

    [coffee_pid, compass_pid].each { |pid| Process.wait(pid) }
  end

  task :run do
    pagoda_pid  = Process.spawn "bin/pagoda ../example-jekyll"
    coffee_pid  = Process.spawn "coffee --compile --watch lib/pagoda/public/js/*.coffee"
    compass_pid = Process.spawn "compass watch ."

    [pagoda_pid, coffee_pid, compass_pid].each { |pid| Process.wait(pid) }    
  end
end

task :watch => ["job:watch"]
task :run   => ["job:run"]