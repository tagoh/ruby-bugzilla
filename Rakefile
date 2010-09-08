require 'rubygems'
require 'rake'
require File.join(File.dirname(__FILE__), "lib", "bugzilla.rb")

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name = "ruby-bugzilla"
    gem.summary = %Q{Ruby binding for Bugzilla WebService APIs}
    gem.description = %Q{This aims to provide similar features to access to Bugzilla through WebService APIs in Ruby.}
    gem.email = "akira@tagoh.org"
    gem.homepage = "http://github.com/tagoh/ruby-bugzilla"
    gem.authors = ["Akira TAGOH"]
    #gem.rubyforge_project = "ruby-bugzilla"
    gem.add_development_dependency "rspec", ">= 1.2.9"
    gem.add_runtime_dependency "gruff"
    gem.add_runtime_dependency "highline"
    # gem is a Gem::Specification... see http://www.rubygems.org/read/chapter/20 for additional settings
    gem.version = Bugzilla::VERSION
    gem.files = FileList['bin/*', 'lib/**/*.rb', '[A-Z]*', 'test/**/*'].to_a.reject{|x| x =~ /~\Z|#\Z|swp\Z/}
    gem.executables.reject!{|x| x =~ /~\Z|#\Z|swp\Z/}
  end
  Jeweler::GemcutterTasks.new
#  Jeweler::RubyforgeTasks.new do |rubyforge|
#    rubyforge.doc_task = "rdoc"
#  end
rescue LoadError
  puts "Jeweler (or a dependency) not available. Install it with: gem install jeweler"
end

require 'spec/rake/spectask'
Spec::Rake::SpecTask.new(:spec) do |spec|
  spec.libs << 'lib' << 'spec'
  spec.spec_files = FileList['spec/**/*_spec.rb']
end

Spec::Rake::SpecTask.new(:rcov) do |spec|
  spec.libs << 'lib' << 'spec'
  spec.pattern = 'spec/**/*_spec.rb'
  spec.rcov = true
end

task :spec => :check_dependencies

task :default => :spec

require 'rake/rdoctask'
Rake::RDocTask.new do |rdoc|
  version = File.exist?('VERSION') ? File.read('VERSION') : ""

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "ruby-bugzilla #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end
