namespace :compass do

  desc "Watch the styles and compile new changes"
  task :watch do
    system "compass watch ."
  end
end