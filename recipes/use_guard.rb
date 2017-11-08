
gem 'guard-rails', group: :development
gem 'guard-rspec', require: false, group: :development
gem 'guard-livereload', group: :development

run 'bundle install'

run 'bundle exec guard init'
