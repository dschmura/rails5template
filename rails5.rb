# template.rb

if yes? 'Do you wish to use bootstrap? (y/n)'
  use_bootstrap = true
end
if yes? 'Do you wish to use devise? (y/n)'
  use_devise = true
end

if yes? 'Do you wish to use bourbon? (y/n)'
  use_bourbon = true
end

if yes? 'Do you wish to use neat? (y/n)'
  user_neat = true
end

gem 'haml-rails'
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
  gem 'guard-rails'
  gem "erb2haml"
end
rails_command("haml:replace_erbs")
generate(:controller, "Pages index about contact privacy")
route "root to: 'pages#index'"
rails_command("db:create")
rails_command("db:migrate")

# Bundle and set up RSpec
run "bundle install"
run "rails generate rspec:install"
# Set up the spec folders for RSpec
run "mkdir spec/models"
run "mkdir spec/controllers"
run "mkdir spec/features"
run "touch spec/factories.rb"

if use_bootstrap
  gem 'bootstrap', '~> 4.0.0.alpha6'
  insert_into_file "app/helpers/application_helper.rb", after: "ApplicationHelper\n" do
    <<-APPHELPER
  def bootstrap_class_for flash_type
    { success: "alert-success", error: "alert-error", alert: "alert-warning", notice: "alert-info" }[flash_type.to_sym] || flash_type.to_s
  end

  def flash_messages(opts = {})
    flash.each do |msg_type, message|
      concat(content_tag(:div, message, class: "alert \#{bootstrap_class_for(msg_type)} fade in") do 
        concat content_tag(:button, 'x', class: "close", data: { dismiss: 'alert' })
          concat message 
      end)
    end
    nil
  end

  APPHELPER
  end

  append_to_file "app/assets/javascripts/application.js", <<-ACTIVE_HEADER
    $(document).on('turbolinks:load', function() {
      setNavigation();
    });

    function setNavigation() {
      var path = window.location.pathname;
      path = path.replace(/\/$/, "");
      path = decodeURIComponent(path);
      var elemental = $("header .navbar-nav li a");
      elemental.each(function() {
        var href = $(this).attr('href');
        if (path.substring(0, href.length) === href) {
            $(this).closest('a').addClass('active');
        }
    });
  }
  ACTIVE_HEADER
end

if use_devise
  gem 'devise'
  run 'rails generate devise:install'
  insert_into_file "config/environments/development.rb", after: "Rails.application.configure do\n" do 
    "config.action_mailer.default_url_options = { host: 'localhost', port: 3000 }"
  end
end

if use_bourbon
  gem 'bourbon'
  gem 'neat', '~> 1.8'
  gem 'bitters'
  run "bourbon install --path app/assets/stylesheets/"
  run "bitters install --path app/assets/stylesheets/"

  insert_into_file 'app/assets/stylesheets/application.css.scss', after: "*/\n" do
  "\n@charset 'utf-8';
  \n@import 'normalize-rails';
  \n@import 'bourbon';
  \n@import 'neat';
  \n@import 'base/base';"
  end
end

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

insert_into_file 'app/helpers/application_helper.rb', after: "ApplicationHelper" do <<-EOF
  
  def site_name
    @site_name = ''
    @site_name = @site_name || Rails.application.class.parent_name.gsub(/[A-Z]/)  { |c| \" \#{c} \"} 
  end
  EOF
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
  "{:class => controller.controller_name}\n    = render 'layouts/header'\n    .content#content"
end

insert_into_file 'app/views/layouts/application.html.haml', after: "= yield" do
  "\n    = render 'layouts/footer'"
end

insert_into_file 'app/views/layouts/application.html.haml', after: "title" do 
  ""
end

run "subl ."
run "cap install"

after_bundle do

  git :init
  git add: "."
  git commit: %Q{ -m 'Initial commit' }
  
end