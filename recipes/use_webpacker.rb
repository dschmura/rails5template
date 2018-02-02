file '.browserlistrc'
append_to_file '.browserlistrc' do
  "> 1%"
end

insert_into_file 'config/application.rb', after: 'config.load_defaults 5.2' do
  <<-GENERATOR_CONFIGS


    config.generators do |g|
      g.test_framework  false
      g.stylesheets     false
      g.javascripts     false
      g.helper          false
      g.channel         assets: false
    end
  GENERATOR_CONFIGS

end



# SET UP ASSETS STRUCTURE FOR WEBPACKER

file 'app/javascript/packs/application.js'
append_to_file "app/javascript/packs/application.js" after: '// layout file, like app/views/layouts/application.html.erb' do
  <<- PACKS_APPLICATION_JS

  import $ from 'jquery'
  global.$ = $
  global.jQuery = $

  import Rails from 'rails-ujs'
  Rails.start()

  import Turbolinks from 'turbolinks'
  Turbolinks.start()

  // Specific frontend applications
  import "#{app_name}"

  PACKS_APPLICATION_JS
end

file "app/javascript/#{app_name}/index.js"
append_to_file "app/javascript/#{app_name}/index.js" do
  <<- INDEX_JS
  // Include external resources for this app_files
  import 'bootstrap'

  // Include internal resources for this app
  import './javascripts/application'

  // require.context('./javascripts/', true, /\.(js)$/i)
  require.context('./stylesheets/', true, /^\.\/[^_].*\.(css|scss|sass)$/i)
  require.context('./images/', true, /\.\/(gif|jpg|png|svg)$/i)


  INDEX_JS
end


# 'app/javascript/packs/application.js'

# yarn add
