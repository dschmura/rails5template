file 'config/nginx.conf'
append_to_file 'config/nginx.conf' do
  <<-NGINX_CONF
upstream #{app_name}-puma {
  server unix:///home/deployer/apps/#{app_name}/shared/tmp/sockets/#{app_name}-puma.sock fail_timeout=0;
}
server {
  listen 80;
  listen [::]:80;
  server_name #{app_name.gsub('_website', '')}.com;

  root /home/deployer/apps/#{app_name}/current/public;
  access_log /home/deployer/apps/#{app_name}/current/log/nginx.access.log;
  error_log /home/deployer/apps/#{app_name}/current/log/nginx.error.log info;

  location ^~ /assets/ {
    gzip_static on;
    expires max;
    add_header Cache-Control public;
  }

  try_files $uri/index.html $uri @puma;
  location @puma {
    proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    proxy_set_header Host $http_host;
    proxy_redirect off;

    proxy_pass http://#{app_name}-puma;
  }

  error_page 500 502 503 504 /500.html;
  client_max_body_size 10M;
  keepalive_timeout 10;
}


  NGINX_CONF
end
