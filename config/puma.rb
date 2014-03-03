directory   File.expand_path('../../', __FILE__)
rackup      File.expand_path('../../config.ru', __FILE__)
state_path  '/var/run/opener-basic.state'
pidfile     '/var/run/opener-basic.pid'

stdout_redirect(
  File.expand_path('../../log/stdout.log', __FILE__),
  File.expand_path('../../log/stderr.log', __FILE__)
)

bind        'tcp://0.0.0.0:80'
daemonize   true
environment 'production'

threads 32, 4096

on_restart do
  ActiveRecord::Base.connection.close if defined?(ActiveRecord)
end
