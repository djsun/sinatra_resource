desc "Run tests"
task :test => %w(db:reset:test test:models test:resources)

namespace :test do
  
  desc "Run model tests"
  Rake::TestTask.new(:models) do |t|
    t.test_files = FileList["test/models/*_test.rb"]
  end

  desc "Run other tests"
  Rake::TestTask.new(:resources) do |t|
    t.test_files = FileList["test/resources/**/*_test.rb"]
  end

end
