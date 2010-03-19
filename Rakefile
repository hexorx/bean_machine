require 'rubygems'
require 'rake'

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name = "bean_machine"
    gem.summary = %Q{Kick accounting in the mean bean machine!}
    gem.description = %Q{Accounting sucks. Well if you are trying to do it right it does. Bean machine gives you the power of an immutable double entry accounting system through the use of a simple transfer method. The idea is to make accounting easy by breaking it into easy to follow steps. Transfer this much from this account to that account.}
    gem.email = "hexorx@gmail.com"
    gem.homepage = "http://crackersnack.com/bean_machine"
    gem.authors = ["hexorx"]
    gem.add_development_dependency "sqlite3"
    gem.add_development_dependency "rspec"
    gem.add_development_dependency "yard"
    gem.add_development_dependency "cucumber"
    gem.add_development_dependency "machinist"
    gem.add_development_dependency "faker"
    # gem is a Gem::Specification... see http://www.rubygems.org/read/chapter/20 for additional settings
  end
  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Jeweler (or a dependency) not available. Install it with: sudo gem install jeweler"
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

begin
  require 'cucumber/rake/task'
  Cucumber::Rake::Task.new(:features)

  task :features => :check_dependencies
rescue LoadError
  task :features do
    abort "Cucumber is not available. In order to run features, you must: sudo gem install cucumber"
  end
end

task :default => :spec

begin
  require 'yard'
  YARD::Rake::YardocTask.new
rescue LoadError
  task :yardoc do
    abort "YARD is not available. In order to run yardoc, you must: sudo gem install yard"
  end
end
