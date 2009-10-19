begin
  require 'yard'
  YARD::Rake::YardocTask.new do |t|
    t.files   = ['lib/**/*.rb']
    # t.options = ['--any', '--extra', '--opts']
  end
rescue LoadError
  task :yardoc do
    abort "YARD is not available. You need to: `gem install yard`"
  end
end


