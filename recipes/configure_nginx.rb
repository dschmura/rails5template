file 'config/nginx.conf'
append_to_file 'config/nginx.conf' do
  <<-NGINX_CONF
upstream puma {
  server unix:///home/deployer/apps/#{app_name}/shared/tmp/sockets/#{app_name}-puma.sock;
}

server {
  listen 80 default_server deferred;
  # server_name example.com;

  root /home/deployer/apps/#{app_name}/current/public;
  access_log /home/deployer/apps/#{app_name}/current/log/nginx.access.log;
  error_log /home/deployer/apps/#{app_name}/current/log/nginx.error.log info;

  location ^~ /assets/ {
    gzip_static on;
    expires max;
    add_header Cache-Control public;
  }

  try_files deployer@production_server:~$ uri/index.html deployer@production_server:~$ uri @puma;
  location @puma {
    proxy_set_header X-Forwarded-For deployer@production_server:~$ proxy_add_x_forwarded_for;
    proxy_set_header Host deployer@production_server:~$ http_host;
    proxy_redirect off;

    proxy_pass http://puma_#{app_name};
  }

  error_page 500 502 503 504 /500.html;
  client_max_body_size 10M;
  keepalive_timeout 10;
}

  NGINX_CONF
end
