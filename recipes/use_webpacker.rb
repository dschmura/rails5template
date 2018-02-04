file '.browserlistrc'
append_to_file '.browserlistrc' do
  # Global config for browserslist, that tools like Autoprefixer are going to need to correctly process your code to be cross-browser compliant. (https://evilmartians.com/chronicles/evil-front-part-1)
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

insert_into_file "app/javascript/packs/application.js", after: "// layout file, like app/views/layouts/application.html.erb" do
  <<-PACKS_APPLICATION_JS

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
  <<-INDEX_JS
  // Include external resources for this app_files
  import 'bootstrap'

  // Include internal resources for this app
  import './javascripts/application'

  // require.context('./javascripts/', true, /\.(js)$/i)
  require.context('./stylesheets/', true, /^\.\/[^_].*\.(css|scss|sass)$/i)
  require.context('./images/', true, /\.\/(gif|jpg|png|svg)$/i)


  INDEX_JS
end

file "app/javascript/#{app_name}/javascripts/application.js"
append_to_file "app/javascript/#{app_name}/javascripts/application.js" do
  <<-APPLICATION_JS
  $(function () {
    $('[data-toggle="tooltip"]').tooltip()
  })

  $(document).on('turbolinks:load', function() {
    var active_elements = $(".navbar-collapse ul li a");
      setActiveLink(active_elements);

    function setActiveLink(active_elements) {
      var path = window.location.pathname;
      path = path.replace(/\$/, "");
      path = decodeURIComponent(path);;
      active_elements.each(function() {
        var href = $(this).attr('href');
        if (path.substring(0, href.length) === href) {
            $(this).closest('a').addClass('active');
        }
      });
    }
  });

  APPLICATION_JS
end

file "app/javascript/#{app_name}/stylesheets/application.sass"
append_to_file "app/javascript/#{app_name}/stylesheets/application.sass" do
  <<-APPLICATION_SASS
  # @import '~bootstrap/scss/functions'
  # @import '~bootstrap/scss/bootstrap'
  @import 'variables'

  // You Forgot The Alt Message
  img[alt=""],
  img:not([alt])
    border: 5px dashed #c00

  APPLICATION_SASS
end

file "app/javascript/#{app_name}/stylesheets/_variables.sass"

gsub_file('app/views/layouts/application.html.haml',  "= stylesheet_link_tag    'application', media: 'all'", "= stylesheet_pack_tag 'application', media: 'all', 'data-turbolinks-track': 'reload'")

gsub_file('app/views/layouts/application.html.haml',  "= javascript_include_tag 'application', 'data-turbolinks-track': 'reload'", "= javascript_pack_tag 'application', 'data-turbolinks-track': 'reload'")

# yarn add