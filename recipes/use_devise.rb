insert_into_file "README.md", after: "* System dependencies\n" do
  <<-DEVISE_README

    ## Authorization - DEVISE
     This application uses Devise for user authorization.

  DEVISE_README
end

gem 'devise', git: 'https://github.com/plataformatec/devise.git', branch: 'master'

after_bundle do
  run 'rails generate devise:install'
  rake db:migrate
  insert_into_file "config/environments/development.rb", after: "Rails.application.configure do\n" do
    "config.action_mailer.default_url_options = { host: 'localhost', port: 3000 }"
  end
end