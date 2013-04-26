Gem::Specification.new do |s|
  s.specification_version = 2 if s.respond_to? :specification_version=
  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.rubygems_version = '1.3.5'
  s.required_ruby_version = ">= 1.8.7"

  s.name              = 'pagoda-jekyll'
  s.version           = '0.0.2'
  s.date              = '2013-03-26'
  s.rubyforge_project = 'pagoda-jekyll'

  s.summary     = "A simple admin for Jekyll"
  s.description = "Admin interface for Jekyll that makes you comfortable writing"

  s.authors  = ["Alagu"]
  s.email    = 'alagu@alagu.net'
  s.homepage = 'http://github.com/alagu/pagoda'

  s.require_paths = %w[lib]

  s.executables = ["pagoda"]

  s.rdoc_options = ["--charset=UTF-8"]
  s.extra_rdoc_files = %w[README.md LICENSE]

  s.add_dependency('jekyll')
  s.add_dependency('grit')
  s.add_dependency('json')
  s.add_dependency('stringex')
  s.add_dependency('sinatra-mustache')
  s.add_dependency('sinatra')
  
  s.add_development_dependency('sinatra-reloader')
  s.add_development_dependency('compass')
  s.add_development_dependency('fssm')
  s.add_development_dependency('rack-test')
  s.add_development_dependency('shoulda')
  s.add_development_dependency('minitest-reporters')


  # = MANIFEST =
  s.files = %w[
    bin/pagoda
    config.rb
    config.ru
    Gemfile
    Gemfile.lock
    lib/pagoda/app.rb
    lib/pagoda/config.rb
    lib/pagoda/helper.rb
    lib/pagoda/jekyll-mod.rb
    lib/pagoda/public/css/pagoda.css
    lib/pagoda/public/images/fullscreen.png
    lib/pagoda/public/js/editor.js
    lib/pagoda/public/js/jquery.autosize.js
    lib/pagoda/public/js/jquery.hotkeys.js
    lib/pagoda/public/js/jquery.js
    lib/pagoda/public/js/screenfull.js
    lib/pagoda/templates/edit.mustache
    lib/pagoda/templates/editor_area.mustache
    lib/pagoda/templates/home.mustache
    lib/pagoda/templates/layout.mustache
    lib/pagoda/templates/new_post.mustache
    lib/pagoda/templates/settings.mustache
    lib/pagoda/views/edit.rb
    lib/pagoda/views/home.rb
    lib/pagoda/views/layout.rb
    lib/pagoda/views/new_post.rb
    lib/pagoda/views/settings.rb
    LICENSE
    pagoda.gemspec
    Rakefile
    README.md
    unicorn.rb
  ]
  # = MANIFEST =

  s.test_files = s.files.select { |path| path =~ /^test\/test_.*\.rb/ }
end
