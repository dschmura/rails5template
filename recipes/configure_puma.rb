file 'config/puma.sample.rb'
append_to_file 'config/puma.sample.rb' do
  <<-PUMA_CONF
#!/usr/bin/env puma

directory '/home/deployer/apps/#{app_name}/current'
rackup "/home/deployer/apps/#{app_name}/current/config.ru"
environment 'production'

pidfile "/home/deployer/apps/#{app_name}/shared/tmp/pids/puma.pid"
state_path "/home/deployer/apps/#{app_name}/shared/tmp/pids/puma.state"
stdout_redirect '/home/deployer/apps/#{app_name}/current/log/puma.error.log', '/home/deployer/apps/#{app_name}/current/log/puma.access.log', true

threads 4,16

bind 'unix:///home/deployer/apps/#{app_name}/shared/tmp/sockets/#{app_name}-puma.sock'

workers 0

preload_app!
on_restart do
  puts 'Refreshing Gemfile'
  ENV["BUNDLE_GEMFILE"] = "/home/deployer/apps/#{app_name}/current/Gemfile"
end

before_fork do
  ActiveRecord::Base.connection_pool.disconnect!
end

on_worker_boot do
  ActiveSupport.on_load(:active_record) do
    ActiveRecord::Base.establish_connection
  end
end



  PUMA_CONF
end
