# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'ssh-copy-id/version'

Gem::Specification.new do |gem|
  gem.name          = "ssh-copy-id.rb"
  gem.version       = SSHCopyID::VERSION
  gem.authors       = ["Junegunn Choi"]
  gem.email         = ["junegunn.c@gmail.com"]
  gem.description   = %q{ssh-copy-id in Ruby. Supports copying to multiple servers.}
  gem.summary       = %q{ssh-copy-id in Ruby. Supports copying to multiple servers.}
  gem.homepage      = "https://github.com/junegunn/ssh-copy-id.rb"

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]
  gem.add_runtime_dependency 'net-ssh',  '>= 2.6'
  gem.add_runtime_dependency 'highline', '>= 1.6.15'
end
