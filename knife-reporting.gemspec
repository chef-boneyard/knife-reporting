$:.unshift(File.dirname(__FILE__) + '/lib')

Gem::Specification.new do |s|
  s.name = "knife-reporting"
  s.version = '0.5.0'
  s.platform = Gem::Platform::RUBY
  s.has_rdoc = false
  s.extra_rdoc_files = ["README.md", "LICENSE"]
  s.summary = "Knife plugin for Opscode Reporting"
  s.description = "Knife plugin for Opscode Reporting.  Adds two new commands 'knife runs show' and 'knife runs list'."
  s.license = "Apache 2"
  s.author = "Chef Software, Inc."
  s.email = "info@getchef.com"
  s.homepage = "https://github.com/chef/knife-reporting"

  s.add_dependency "mixlib-cli", "~> 1.5"

  s.require_path = 'lib'
  s.files = %w(LICENSE README.md Rakefile) + Dir.glob("{lib,spec}/**/*")
end

