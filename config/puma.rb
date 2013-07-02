directory   File.expand_path('../../', __FILE__)
rackup      File.expand_path('../../config.ru', __FILE__)
state_path  File.expand_path('../../tmp/puma.state', __FILE__)

stdout_redirect File.expand_path('../../log/stdout.log', __FILE__)
stderr_redirect File.expand_path('../../log/stderr.log', __FILE__)

bind        'localhost', 80
daemonize   true
environment 'production'

# Minimum of 0 threads, maximum of 512.
threads 0, 512
workers 4

on_worker_boot do
  ActiveRecord::Base.establish_connection if defined?(ActiveRecord)
end
