Gem::Specification.new do |s|
  s.specification_version = 2 if s.respond_to? :specification_version=
  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.rubygems_version = '1.3.5'
  s.required_ruby_version = ">= 1.8.7"

  s.name              = 'pagoda'
  s.version           = '0.0.1'
  s.date              = '2013-03-22'
  s.rubyforge_project = 'pagoda'

  s.summary     = "A simple admin for Jekyll"
  s.description = "A simple admin for Jekyll"

  s.authors  = ["Alagu"]
  s.email    = 'alagu@alagu.net'
  s.homepage = 'http://github.com/alagu/pagoda'

  s.require_paths = %w[lib]

  s.executables = ["pagoda"]

  s.rdoc_options = ["--charset=UTF-8"]
  s.extra_rdoc_files = %w[README.md LICENSE]

  s.add_dependency('jekyll')


  # = MANIFEST =
  s.files = %w[
  ]
  # = MANIFEST =

  s.test_files = s.files.select { |path| path =~ /^test\/test_.*\.rb/ }
end
