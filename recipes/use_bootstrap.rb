# gem 'bootstrap', '~> 4.0.0.beta3'
# gem 'popper_js'
# gem 'jquery-rails'

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

#   insert_into_file "app/assets/javascripts/application.js", after: "// about supported directives.\n//\n" do
#     "\n//= require jquery2\n//= require popper\n//= require bootstrap\n"
#   end
#
#
#
#   insert_into_file "app/assets/stylesheets/application.scss", after: " */\n" do
#     "@charset 'utf-8';
#     \n@import 'normalize-rails';
#     \n@import 'font-awesome';"
#   end
#
#   append_to_file "app/assets/stylesheets/application.scss", <<-BOOTSTRAP_STYLE
#   // Custom bootstrap variables must be set or imported before bootstrap itself.
# @import "bootstrap";
# BOOTSTRAP_STYLE



# Create and link partials for header and footer
append_to_file "app/views/layouts/_header.html.haml" do
<<-BOOTSTRAP_HEADER
%header
  / Navigation
  %nav#mainNav.navbar.fixed-top.navbar-expand-md.navbar-dark.bg-dark.mb-4
    %button.navbar-toggler{"aria-controls" => "navbarCollapse", "aria-expanded" => "false", "aria-label" => "Toggle navigation", "data-target" => "#navbarCollapse", "data-toggle" => "collapse", :type => "button"}
      %span.navbar-toggler-icon
    #navbarCollapse.collapse.navbar-collapse
      %ul.navbar-nav.mr-auto.text-uppercase
        %li.nav-item
          = link_to site_name, root_path, class: 'navbar-brand', id: root_path(anchor: 'page-top')
          %span.sr-only (current)

      .nav.my-2.my-md-0
        %ul.navbar-nav.text-uppercase.ml-auto
          %li.nav-item= link_to "About", about_path, class:"nav-link"
          %li.nav-item= link_to "Contact Us", contact_path, class:"nav-link"
          %li.nav-item= link_to "Privacy", privacy_path, class:"nav-link"

  BOOTSTRAP_HEADER

end

append_to_file "app/views/layouts/_footer.html.haml" do
<<-BOOTSTRAP_FOOTER
%footer.fixed-bottom.bg-dark
  .d-flex.flex-row.justify-content-between.align-items-center
    .footer-logo
      -# = link_to image_tag("\#{site_name}Logo.png", class: 'navbar-brand navbar-logo', alt: "\#{site_name} Logo, link to home page."), root_path
      = link_to site_name, root_path, class:'navbar-brand'
    .footer-links
      %ul.navbar-nav.flex-row.justify-content-around
        %li.nav-item= link_to 'About', about_path, class:'nav-link'
        %li.nav-item= link_to 'Contact Us', contact_path, class:'nav-link'
        %li.nav-item= link_to 'Privacy Policy', privacy_path, class:'nav-link'
      .footer-copyright.text-center
        = link_to "© 2018 - Copyright \#{site_name}, All Rights Reserved", about_path

  BOOTSTRAP_FOOTER

end
