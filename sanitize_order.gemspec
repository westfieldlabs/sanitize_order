# coding: utf-8
require_relative 'lib/sanitize_order/version'

Gem::Specification.new do |spec|
  spec.name          = 'sanitize_order'
  spec.version       = SanitizeOrder::VERSION
  spec.authors       = ['Michael Mell', 'George Shaw']
  spec.email         = ['mike.mell@nthwave.net', 'gshaw@westfield.com']

  spec.summary       = %q{Sanitize an sql order clause from tainted params}
  spec.description   = %q{Sanitize an sql order clause from tainted params}
  spec.homepage      = 'https://github.com/westfield/sanitize_order'
  spec.license       = 'Apache-2.0'

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = 'bin'
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.require_paths = ['lib', 'app']

  spec.required_ruby_version = '>= 2.2.2'

  spec.add_dependency 'activerecord', '~> 4.2.0'
  spec.add_dependency 'activesupport', '~> 4.2.0'

  spec.add_development_dependency 'bundler', '~> 1.3'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'rspec', '~> 3.2'
  spec.add_development_dependency 'sqlite3'
  spec.add_development_dependency 'database_cleaner'
end
