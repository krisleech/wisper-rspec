# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'wisper/rspec/version'

Gem::Specification.new do |spec|
  spec.name          = "wisper-rspec"
  spec.version       = Wisper::Rspec::VERSION
  spec.authors       = ["Kris Leech"]
  spec.email         = ["kris.leech@gmail.com"]
  spec.summary       = "Rspec matchers and stubbing for Wisper"
  spec.description   =  "Rspec matchers and stubbing for Wisper"
  spec.homepage      = "https://github.com/krisleech/wisper-rspec"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  signing_key = File.expand_path(ENV['HOME'].to_s + '/.ssh/gem-private_key.pem')

  if File.exist?(signing_key)
    spec.signing_key = signing_key
    spec.cert_chain  = ['gem-public_cert.pem']
  else
    puts "Warning: NOT CREATING A SIGNED GEM. Could not find signing key: #{signing_key}"
  end
end
