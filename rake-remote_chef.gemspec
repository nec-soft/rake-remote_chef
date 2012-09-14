# -*- encoding: utf-8 -*-
require File.expand_path('../lib/rake/remote_chef/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["yuanying"]
  gem.email         = ["yuanying@fraction.jp"]
  gem.description   = %q{Execute chef-solo with Rake::RemoteTask to remote host.}
  gem.summary       = %q{Execute chef-solo with Rake::RemoteTask to remote host.}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "rake-remote_chef"
  gem.require_paths = ["lib"]
  gem.version       = Rake::RemoteChef::VERSION

  gem.add_runtime_dependency "hoe"
  gem.add_runtime_dependency "rake-remote_task"
  gem.add_runtime_dependency "tempdir"
  gem.add_runtime_dependency "json"
  gem.add_runtime_dependency "deep_merge"
end
