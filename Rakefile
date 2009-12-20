require 'rubygems'
require 'rake'
require 'rake/clean'
require 'rake/gempackagetask'
require 'rake/rdoctask'
require 'rake/testtask'

spec = Gem::Specification.new do |s|
  s.name = 'database-yml'
  s.version = '0.0.1'
  s.has_rdoc = true
  s.extra_rdoc_files = ['README.rdoc', 'LICENSE']
  s.summary = 'Configurable database setup for Sinatra'
  s.description = s.summary
  s.author = 'Vasil Taneski'
  s.email = 'vasil.taneski@gmail.com'
  s.files = %w(LICENSE README.rdoc Rakefile) + Dir.glob("{bin,lib,test}/**/*")
  s.require_path = "lib"
  s.bindir = "bin"
end

Rake::GemPackageTask.new(spec) do |p|
  p.gem_spec = spec
  p.need_tar = true
  p.need_zip = true
end

Rake::RDocTask.new do |rdoc|
  files =['README.rdoc', 'LICENSE', 'lib/**/*.rb']
  rdoc.rdoc_files.add(files)
  rdoc.main = "README.rdoc"
  rdoc.title = "database-yml Docs"
  rdoc.rdoc_dir = 'doc/rdoc'
  rdoc.options << '--line-numbers'
end

Rake::TestTask.new do |t|
  t.test_files = FileList['test/**/*.rb']
end
