$:.unshift(File.dirname(__FILE__) + '/lib')

Gem::Specification.new do |s|
  s.name = "knife-reporting"
  s.version = '0.3.1'
  s.platform = Gem::Platform::RUBY
  s.has_rdoc = false
  s.extra_rdoc_files = ["README.md", "LICENSE"]
  s.summary = "Knife plugin for Opscode Reporting"
  s.description = s.summary
  s.author = "Matthew Peck"
  s.email = "matthew@opscode.com"
  s.homepage = "http://www.opscode.com"

  s.add_dependency "mixlib-cli", ">= 1.2.2"

  s.require_path = 'lib'
  s.files = %w(LICENSE README.md Rakefile) + Dir.glob("{lib,spec}/**/*")
end

