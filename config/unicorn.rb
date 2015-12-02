require 'fileutils'

dir = File.expand_path "#{__dir__}/.."
working_directory dir

# Unicorn PID file location
# pid "/path/to/pids/unicorn.pid"
FileUtils.mkdir "#{dir}/pids" unless File.directory?("#{dir}/pids")
FileUtils.mkdir "#{dir}/logs" unless File.directory?("#{dir}/logs")
pid "#{dir}/pids/unicorn.pid"


stdout_path "#{dir}/logs/unicorn.log"
stderr_path "#{dir}/logs/unicorn.err.log"

# Unicorn socket
listen "/tmp/unicorn.lenny.sock"

# Number of processes
# worker_processes 4
worker_processes 1

# Time-out
timeout 10