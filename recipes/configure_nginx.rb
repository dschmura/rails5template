file 'config/nginx.conf'
append_to_file 'config/nginx.conf' do
  <<-NGINX_CONF
upstream #{app_name}-puma {
  server unix:///home/deployer/apps/#{app_name}/shared/tmp/sockets/#{app_name}-puma.sock fail_timeout=0;
}
server {
  server_name #{app_name}.com www.#{app_name}.com;

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
 # managed by Certbot

    listen 443 ssl; # managed by Certbot
    ssl_certificate /etc/letsencrypt/live/#{app_name}.com/fullchain.pem; # managed by Certbot
    ssl_certificate_key /etc/letsencrypt/live/#{app_name}.com/privkey.pem; # managed by Certbot
    include /etc/letsencrypt/options-ssl-nginx.conf; # managed by Certbot
    ssl_dhparam /etc/letsencrypt/ssl-dhparams.pem; # managed by Certbot


}

server {
    if ($host = www.#{app_name}.com) {
        return 301 https://$host$request_uri;
    } # managed by Certbot


    if ($host = #{app_name}.com) {
        return 301 https://$host$request_uri;
    } # managed by Certbot


  server_name #{app_name}.com www.#{app_name}.com;
    listen 80;
    return 404; # managed by Certbot
}


  NGINX_CONF
end
