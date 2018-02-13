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
  username: <%= Rails.application.credentials.STAGING_DB_USERNAME %>
  password: <%= Rails.application.credentials.STAGING_DB_PASSWORD %>

production:
  <<: *default
  database: #{app_name}_production
  username: <%= Rails.application.credentials.PRODUCTION_DB_USERNAME %>
  password: <%= Rails.application.credentials.PRODUCTION_DB_PASSWORD %>

  DATABASE_YML

end
