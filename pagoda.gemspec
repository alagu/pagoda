Gem::Specification.new do |s|
  s.specification_version = 2 if s.respond_to? :specification_version=
  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.rubygems_version = '1.3.5'
  s.required_ruby_version = ">= 1.8.7"

  s.name              = 'pagoda-jekyll'
  s.version           = '0.0.11'
  s.date              = '2013-06-09'
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
  s.add_dependency('sinatra-reloader')
  
  s.add_development_dependency('compass')
  s.add_development_dependency('fssm')
  s.add_development_dependency('rack-test')
  s.add_development_dependency('dotenv')
  s.add_development_dependency('shoulda')
  s.add_development_dependency('minitest-reporters')


  # = MANIFEST =
  s.files = Dir['bin/*'] + Dir['lib/**/*'] +
  %w[
    config.rb
    config.ru
    Gemfile
    Gemfile.lock
    LICENSE
    pagoda.gemspec
    Rakefile
    unicorn.rb
  ]
  # = MANIFEST =

  s.test_files = s.files.select { |path| path =~ /^test\/test_.*\.rb/ }
end
