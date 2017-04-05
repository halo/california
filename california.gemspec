require File.expand_path('../lib/california/version', __FILE__)

Gem::Specification.new do |spec|

  spec.name        = 'california'
  spec.version     = California::VERSION
  spec.date        = '2017-04-05'
  spec.summary     = 'Capistrano 3 for dummies.'
  spec.description = 'See https://github.com/halo/california'
  spec.authors     = ['halo']
  spec.homepage    = 'https://github.com/halo/california'

  spec.files       = Dir['Rakefile', '{bin,lib,man,test,spec}/**/*', 'README*', 'LICENSE*'] & `git ls-files -z`.split("\0")
  spec.executables = ['california']

  spec.add_dependency 'capistrano', '~> 3.8'
  spec.add_dependency 'thor', '~> 0.19'

  spec.add_development_dependency 'rspec'
  spec.add_development_dependency 'guard-rspec'
  spec.add_development_dependency 'rb-fsevent'
  spec.add_development_dependency 'rubocop'

end
