Gem::Specification.new do |s|
  s.name = "triez"
  s.version = "1.0.7"  # Increment the version number
  s.author = "luikore"
  s.homepage = "https://github.com/luikore/triez"
  s.platform = Gem::Platform::RUBY
  s.summary = "fast, efficient, unicode aware HAT trie with prefix / suffix support"
  s.description = "fast, efficient, unicode aware HAT trie with prefix / suffix support."
  s.required_ruby_version = ">= 2.0.0"  # Update the minimum Ruby version
  s.license = "MIT" # or whatever license the project uses
  s.files = Dir.glob("{copying,changes,readme.md,{lib,test}/*.rb,ext/*.{c,cc,h,rb},ext/hat-trie/*}")
  s.require_paths = ["lib"]
  s.extensions = ["ext/extconf.rb"]
  s.required_rubygems_version = ">= 2.0.0" # or a more recent version
  s.has_rdoc = false

end