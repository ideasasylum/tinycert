
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "tinycert/version"

Gem::Specification.new do |spec|
  spec.name          = "tinycert"
  spec.version       = Tinycert::VERSION
  spec.authors       = ["Jamie Lawrence"]
  spec.email         = ["jamie@ideasasylum.com"]

  spec.summary       = %q{Tinycert api client}
  spec.description   = %q{A small gem for interacting with the Tinycert.org API}
  spec.homepage      = "http://github.com/ideasasylum/tinycert"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.16"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "pry"
end
