# template.rb



gem 'haml-rails'
gem 'bourbon'
gem 'neat', '~> 1.8'
gem 'normalize-rails'
gem 'font-awesome-rails'

gem_group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug'
  gem 'rspec-rails', '~>3.5.0'
  gem 'factory_girl_rails'
  gem 'annotate', '~> 2.7'
end

gem_group :test do
  gem 'shoulda-matchers', require: false
  gem 'ffaker'
  gem 'capybara'
  ## These are reccomended in the 'Everyday Rails Testing with RSPEC'
  gem "database_cleaner"
  gem "selenium-webdriver"
end

gem_group :development do
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
  gem 'capistrano-rails'
  gem 'capistrano-postgresql', '~> 4.2.0'
  gem 'capistrano-rvm'
  gem 'capistrano-passenger'
  gem "erb2haml"
end
rails_command("haml:replace_erbs")
generate(:controller, "Pages index about contact")
route "root to: 'pages#index'"
rails_command("db:migrate")

# Bundle and set up RSpec
run "bundle install"
run "rails generate rspec:install"
# Set up the spec folders for RSpec
run "mkdir spec/models"
run "mkdir spec/controllers"
run "mkdir spec/features"
run "touch spec/factories.rb"
run "bourbon install"
# Inject into the factory girl files
append_to_file "spec/factories.rb" do
  "FactoryGirl.define do\nend"
end

insert_into_file "spec/rails_helper.rb", after: "RSpec.configure do |config|\n" do
  "  config.include FactoryGirl::Syntax::Methods\n"
end

# Set up Database Cleaner
insert_into_file "spec/rails_helper.rb", after: "RSpec.configure do |config|\n" do
  "  config.before(:suite) do\n    DatabaseCleaner.clean_with(:truncation)\n  end\n\n
  config.before(:each) do\n    DatabaseCleaner.strategy = :transaction\n  end\n\n
  config.before(:each, :js => true) do\n    DatabaseCleaner.strategy = :truncation\n  end\n\n
  config.before(:each) do\n    DatabaseCleaner.start\n  end\n\n
  config.after(:each) do\n    DatabaseCleaner.clean\n  end\n\n"
end

gsub_file "spec/rails_helper.rb",
          "config.use_transactional_fixtures = true",
          "config.use_transactional_fixtures = false"

# Set up Shoulda Matchers
append_to_file "spec/rails_helper.rb" do
  "\nShoulda::Matchers.configure do |config|\n  config.integrate do |with|\n    with.test_framework :rspec\n    with.library :rails\n  end\nend"
end

# Set up for scss and bootstrap
run "mv app/assets/stylesheets/application.css app/assets/stylesheets/application.css.scss"
run "touch app/assets/stylesheets/custom.css.sass"
gsub_file('app/assets/stylesheets/application.css.scss',  '*= require_tree .', '')


insert_into_file 'app/assets/stylesheets/application.css.scss', after: "*/\n" do
  "\n@charset 'utf-8';
  \n@import 'normalize-rails';
  \n@import 'bourbon';
  \n@import 'neat';
  \n@import 'base/base';
  \n@import 'refills/flashes';"
  end

# Create and link partials for header and footer
create_file "app/views/layouts/_header.html.haml" do 
  <<-EOF

%header
  %nav
    %ul 
      %li 
      %li
      %li
  EOF
end


create_file "app/views/layouts/_footer.html.haml" do 
  <<-EOF

%footer
  %nav
    %ul 
      %li 
      %li
      %li
  EOF
end

insert_into_file 'app/views/layouts/application.html.haml', after: "%body" do
  "\n  = render 'header'"
end
insert_into_file 'app/views/layouts/application.html.haml', after: "= yield" do
  "\n  = render 'footer'"
end


capify!
after_bundle do

  git :init
  git add: "."
  git commit: %Q{ -m 'Initial commit' }
  run "subl ."
end