require "bundler/gem_tasks"
require "rake/testtask"

Rake::TestTask.new do |t|
  t.libs << 'minitest'
  t.test_files = FileList["lib/{,**/}*_spec.rb"]
  t.verbose = true
end
