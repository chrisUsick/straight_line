# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'common/command'

Gem::Specification.new do |spec|
  spec.name          = 'straight_line'
  spec.version       = File.read('VERSION').strip
  spec.authors       = ['Chris Usick']
  spec.email         = ['christopher.usick@gmail.com']

  spec.summary       = 'Rake commands to perform simple git workflow'
  spec.description   = %(
This module provides an opinionated git workflow)
  spec.homepage      = 'https://github.com/chrisUsick/straight_line'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.13'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_dependency 'thor'
  spec.add_dependency 'octokit'
  spec.add_dependency 'netrc'
end
