# -*- encoding: utf-8 -*-
require File.expand_path('../lib/rake-remote_task-chef-solo/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["yuanying"]
  gem.email         = ["yuanying@fraction.jp"]
  gem.description   = %q{TODO: Write a gem description}
  gem.summary       = %q{TODO: Write a gem summary}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "rake-remote_task-chef-solo"
  gem.require_paths = ["lib"]
  gem.version       = Rake::RemoteTask::Chef::Solo::VERSION

  gem.add_runtime_dependency "hoe"
  gem.add_runtime_dependency "rake-remote_task"
  gem.add_runtime_dependency "tempdir"
  gem.add_runtime_dependency "json"
end
