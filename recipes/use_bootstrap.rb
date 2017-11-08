  gem 'bootstrap', '~> 4.0.0.beta2.1'
  gem 'popper_js', '~> 1.12.3'

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
  insert_into_file "app/assets/javascripts/application.js", after: "//= require jquery\n" do
    "\n//= require tether\n//= require bootstrap\n"
  end

  append_to_file "app/assets/javascripts/application.js", <<-ACTIVE_HEADER
    $(document).on('turbolinks:load', function() {
      setActiveLink();
    });

    function setActiveLink() {
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

  insert_into_file "app/assets/stylesheets/application.scss", after: " */\n" do
    "@charset 'utf-8';
    \n@import 'normalize-rails';
    \n@import 'font-awesome';"
  end

  append_to_file "app/assets/stylesheets/application.scss", <<-BOOTSTRAP_STYLE
  // Custom bootstrap variables must be set or imported before bootstrap itself.
@import "bootstrap";
BOOTSTRAP_STYLE



# Create and link partials for header and footer
create_file "app/views/layouts/_header.html.haml" do
<<-BOOTSTRAP_HEADER
%header
%nav.navbar.navbar-toggleable-md.navbar-inverse.fixed-top.bg-inverse
  %button.navbar-toggler.navbar-toggler-right{"aria-controls" => "headerNavBar", "aria-expanded" => "false", "aria-label" => "Toggle navigation", "data-target" => "#headerNavBar", "data-toggle" => "collapse", :type => "button"}
    %span.navbar-toggler-icon
  = link_to site_name, root_path, class:"navbar-brand"
  #headerNavBar.collapse.navbar-collapse
    %ul.navbar-nav.ml-auto
      %li.nav-item= link_to "About", pages_about_path, class:"nav-link"
      %li.nav-item= link_to "Contact Us", pages_contact_path, class:"nav-link"
      %li.nav-item= link_to "Privacy", pages_privacy_path, class:"nav-link"
  BOOTSTRAP_HEADER

  # if use_devise do
  #   insert_into_file  "app/views/layouts/_header.html.haml", after "%li.nav-item= link_to \"Privacy\", pages_privacy_path, class:\"nav-link\"" do
  #   <<-DEVISE_LOGIN_HEADER
  #   %li.nav-item
  #   - if user_signed_in?
  #     = link_to "Profile", edit_user_path(current_user.id)
  #   - else
  #     = link_to "User Login", new_user_session_path"

  #   DEVISE_LOGIN_HEADER
  #   end
  # end
end


