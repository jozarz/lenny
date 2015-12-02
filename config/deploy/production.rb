# config valid only for current version of Capistrano
lock '3.4.0'



server '46.101.237.165', user: 'root', roles: %w{app}

set :branch, 'master'
set :deploy_to, '/srv/http/lenny'

set :rvm_type, :user
set :rvm_custom_path, '/usr/local/rvm'

set :unicorn_pid, -> { File.join(current_path, "pids", "unicorn.pid") }
set :unicorn_config_path, -> { File.join(current_path, "config", "unicorn.rb") }
set :linked_dirs, ['logs', 'tmp/pids', 'pids']

after 'deploy:publishing', 'unicorn:reload'


