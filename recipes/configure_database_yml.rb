# CONFIG THE DATABASE.yml
run 'rm config/database.yml'
file 'config/database.yml'
append_to_file 'config/database.yml' do
  <<-DATABASE_YML
default: &default
  adapter: postgresql
  encoding: unicode

development:
  <<: *default
  database: #{app_name}_development

test:
  <<: *default
  database: #{app_name}_test

staging:
  <<: *default
  database: #{app_name}_staging
  username: <%= Rails.application.secrets.staging_db_username %>
  password: <%= Rails.application.secrets.staging_db_password %>

production:
  <<: *default
  database: #{app_name}_production
  username: <%= Rails.application.secrets.production_db_username %>
  password: <%= Rails.application.secrets.production_db_password %>

  DATABASE_YML

end
