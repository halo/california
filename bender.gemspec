Gem::Specification.new do |spec|

  spec.name        = 'bender'
  spec.version     = '0.0.1'
  spec.date        = '2014-06-08'
  spec.summary     = 'Capistrano 3 for dummies.'
  spec.description = "See https://github.com/halo/bender"
  spec.authors     = %w{ halo }
  spec.homepage    = 'https://github.com/halo/bender'

  spec.files       = Dir['Rakefile', '{bin,lib,man,test,spec}/**/*', 'README*', 'LICENSE*'] & `git ls-files -z`.split("\0")

  spec.add_dependency 'capistrano', '3.2.1'
  spec.add_dependency 'logging', '1.8.2'

  spec.add_development_dependency 'rspec'
  spec.add_development_dependency 'guard-rspec'
  spec.add_development_dependency 'rb-fsevent'

end
