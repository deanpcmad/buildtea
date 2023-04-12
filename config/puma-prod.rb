threads_count = ENV["RAILS_MAX_THREADS"] || 5
threads         threads_count, threads_count
# bind_address  = '127.0.0.1'
bind_address  = '0.0.0.0'
bind_port     = ENV['PORT'] || 5000
bind            "tcp://#{bind_address}:#{bind_port}"
environment     ENV["RAILS_ENV"] || 'development'
prune_bundler
quiet false
