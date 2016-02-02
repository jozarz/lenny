require 'erb'

namespace :prepare do
  task :nginx do
    FileUtils.mkdir('tmp') unless File.directory?('tmp')
    erb = File.read('config/nginx.erb')
    root = File.expand_path(__dir__)
    File.write('tmp/lenny', ERB.new(erb).result(binding))
  end
end
