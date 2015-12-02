# config valid only for current version of Capistrano
lock '3.4.0'

set :application, 'lenny'
set :repo_url, 'git@example.com:me/my_repo.git'

server '46.101.237.165', user: 'root', roles: %w{app}

set :branch, 'master'
set :deploy_to, '/srv/http/lenny'

set :rvm_type, :user
set :rvm_custom_path, '/usr/local/rvm'

after 'deploy:publishing', 'unicorn:reload'


