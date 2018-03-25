# -*- encoding: utf-8 -*-

lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'errbit_trello_plugin/version'

Gem::Specification.new do |gem|
  gem.name          = "errbit_trello_plugin"
  gem.version       = ErrbitTrelloPlugin::VERSION
  gem.summary       = %q{Trello integration for Errbit}
  gem.description   = %q{Trello integration for Errbit}
  gem.license       = "MIT"
  gem.authors       = ["Vladislav Yashin"]
  gem.email         = "v.yashin.work@gmail.com"
  gem.homepage      = "https://rubygems.org/gems/errbit_trello_plugin"

  gem.files         = `git ls-files`.split($/)

  `git submodule --quiet foreach --recursive pwd`.split($/).each do |submodule|
    submodule.sub!("#{Dir.pwd}/",'')

    Dir.chdir(submodule) do
      `git ls-files`.split($/).map do |subpath|
        gem.files << File.join(submodule,subpath)
      end
    end
  end
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ['lib']

  gem.add_runtime_dependency 'errbit_plugin', '~> 0'
  gem.add_runtime_dependency 'ruby-trello', '~> 2.0'

  gem.add_development_dependency 'bundler', '~> 1.10'
  gem.add_development_dependency 'rake', '~> 10.0'
  gem.add_development_dependency 'rspec', '~> 3.0'
  gem.add_development_dependency 'rubygems-tasks', '~> 0.2'
  gem.add_development_dependency 'yard', '~> 0.8'
end
