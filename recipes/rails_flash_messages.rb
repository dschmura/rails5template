# rails flash message settings
run "touch app/views/layouts/_flash_messages.html.erb"
run "rm app/helpers/application_helper.rb"
run "touch app/helpers/application_helper.rb"
append_file "app/views/layouts/_flash_messages.html.erb", <<-CODE
<div>
  <% flash.each do |key, value| %>
    <div class="<%= flash_class(key) %> fade in">
      <a href="#" data-dismiss="alert" class="close">×</a>
      <%= value %>
    </div>
  <% end %>
</div>
CODE
append_file "app/helpers/application_helper.rb", <<-CODE
module ApplicationHelper
  def flash_class(level)
    case level
    when :notice then "alert alert-info"
    when :success then "alert alert-success"
    when :error then "alert alert-error"
    when :alert then "alert alert-error"
    end
  end
end
CODE



