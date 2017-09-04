# template.rb

def source_paths
  Array(super) + [File.join(File.expand_path(File.dirname(__FILE__)),'recipes')]
end
def template_with_env filename
  if ENV['LOCAL']
    "/Users/dschmura/code/Rails/TEMPLATES/rails5template/recipes" + filename
  else
    "http://github.com/smartlogic/rails-templates/raw/master/" + filename
  end
end

# Loads templates from the recipes/ directory (located in the same directory as this template).
# This allows us to load templates in the form: load_template('rails_flash_messages.rb')
def load_template(template)
  begin
    template = File.join(File.dirname(__FILE__), "/recipes/#{template}")
    code = open(template).read
    in_root { self.instance_eval(code) }
  rescue LoadError, Errno::ENOENT => e
    raise "The template [#{template}] could not be loaded. Error: #{e}"
    end
end

# All apps get flash messages
load_template('rails_flash_messages.rb')


if yes? 'Do you wish to use bootstrap? (y/n)'
  use_bootstrap = true
end
if yes? 'Do you wish to use capistrano? (y/n)'
  use_capistrano = true
end

if yes? 'Generate a favicon? (y/n)'
  create_favicon = true
end

if yes? 'Do you wish to use devise? (y/n)'
  use_devise = true
end

if yes? 'Do you wish to use bourbon? (y/n)'
  use_bourbon = true
end

if yes? 'Do you wish to use guard? (y/n)'
  use_guard = true
end
if yes? 'Do you wish to include a mailer? (y/n)'
  use_mailer = true
end

# gem 'haml', '~> 5.0.0.beta.2'
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
  gem 'shoulda-matchers'
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
  # Invoke rake tasks on remote server.
  # example use: cap staging    invoke:rake TASK=db:seed
  gem 'capistrano-rake', require: false
  gem 'erb2haml'
  gem 'pry'
  gem 'pry-rails'
end

if use_guard
  load_template('use_guard.rb')
end

if create_favicon
  load_template('create_favicon.rb')
end

if use_mailer
  load_template('use_mailer.rb')
end


rails_command("haml:replace_erbs")
generate(:controller, "Pages index about contact privacy")
route "root to: 'pages#index'"
rails_command("db:create")
rails_command("db:migrate")

# Bundle and set up RSpec

run "rails generate rspec:install"
# Set up the spec folders for RSpec
run "mkdir spec/models"
run "mkdir spec/controllers"
run "mkdir spec/features"
run "touch spec/factories.rb"

# Set up for scss
run "mv app/assets/stylesheets/application.css app/assets/stylesheets/application.scss"
run "touch app/assets/stylesheets/custom.sass"
gsub_file('app/assets/stylesheets/application.scss',  '*= require_tree .', '')


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


# Set up SiteName Helper
insert_into_file 'app/helpers/application_helper.rb', after: "ApplicationHelper" do <<-EOF

  def site_name
    @site_name = nil
    @site_name = @site_name || Rails.application.class.parent_name.titleize
  end
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

if use_bourbon
  load_template('use_bourbon.rb')
end

if use_bootstrap
  load_template('use_bootstrap.rb')
end

if use_devise
  load_template('use_devise.rb')
end

if use_capistrano
  load_template('use_capistrano.rb')
end

# Add a class for the name of the controller.
insert_into_file 'app/views/layouts/application.html.haml', after: "%body" do
  "{:class => controller.controller_name}\n    = render 'layouts/header'\n    .content#content"
end

insert_into_file 'app/views/layouts/application.html.haml', after: "= yield" do
  "\n    = render 'layouts/footer'"
end

insert_into_file 'app/views/layouts/application.html.haml', after: "title" do
  ""
end


##Configure Shoulda-matchers for Rails 5 compatability
insert_into_file 'spec/rails_helper.rb', after: "require 'rspec/rails'" do
<<-SHOULDA

Shoulda::Matchers.configure do |config|
  config.integrate do |with|
    with.test_framework :rspec
    with.library :rails
  end
end
SHOULDA
end

run "subl ."


after_bundle do

  git :init
  git add: "."
  git commit: %Q{ -m 'Initial commit' }

end
