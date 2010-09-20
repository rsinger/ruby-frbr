require "rake"

require "spec/rake/spectask"



desc "Run all specs"

Spec::Rake::SpecTask.new("specs") do |t|

  t.spec_files = FileList["specs/*.rb"]

end

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gemspec|
    gemspec.name = "frbr"
    gemspec.summary = "A set of modules for creating simple FRBR relationships between objects."
    gemspec.description = "A set of modules for creating simple FRBR (Functional Requirements for Bibliographic Resources) relationships between objects.  Includes Group 1, 2 and 3 entities."
    gemspec.email = "rossfsinger@gmail.com"
    gemspec.homepage = "http://github.com/rsinger/ruby-frbr"
    gemspec.authors = ["Ross Singer"]
    gemspec.files = Dir.glob("{lib,spec}/**/*") + ["README", "LICENSE"]
    gemspec.require_path = 'lib'    
  end
rescue LoadError
  puts "Jeweler not available. Install it with: sudo gem install technicalpickles-jeweler -s http://gems.github.com"
end