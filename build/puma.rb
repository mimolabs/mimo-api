# bind "unix:///var/run/puma.sock"
port 8080
environment "production"
threads 4,16
preload_app!

# before_fork do
#   ActiveRecord::Base.connection_pool.disconnect!
# end
