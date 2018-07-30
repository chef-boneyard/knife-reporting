$:.unshift(File.dirname(__FILE__) + "/lib")

Gem::Specification.new do |s|
  s.name = "knife-reporting"
  s.version = "0.6.0"
  s.extra_rdoc_files = ["README.md", "LICENSE"]
  s.summary = "Knife plugin for Chef Reporting"
  s.description = "Knife plugin for Chef Reporting. Adds two new commands 'knife runs show' and 'knife runs list'."
  s.license = "Apache-2.0"
  s.author = "Chef Software, Inc."
  s.email = "info@chef.io"
  s.homepage = "https://github.com/chef/knife-reporting"

  s.required_ruby_version = ">= 2.2.2"
  s.add_dependency "mixlib-cli", "~> 1.5"

  s.require_path = "lib"
  s.files = %w{LICENSE README.md Rakefile} + Dir.glob("{lib,spec}/**/*")
end
