listen 80

stdout_path File.expand_path('../../log/stdout.log', __FILE__)
stderr_path File.expand_path('../../log/stderr.log', __FILE__)
pid File.expand_path('../../tmp/unicorn.pid', __FILE__)

working_directory File.expand_path('../../', __FILE__)
worker_processes 5
preload_app false
