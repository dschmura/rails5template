## Setup letter_opener for development
gem_group :development, :test do
  gem 'letter_opener'
end

insert_into_file 'config/environments/development.rb', after: 'Rails.application.configure do' do
  <<-LETTER_OPENER
  # Support for letter_opener
    config.action_mailer.delivery_method = :letter_opener
    config.action_mailer.perform_deliveries = true
    config.action_mailer.raise_delivery_errors = true
  LETTER_OPENER
end

rails_command("g model Feedback --skip-migration")

create_file 'config/initializers/mailer_setup.rb' do
  <<-ACTION_MAILER_SETUP
  ActionMailer::Base.delivery_method = :smtp
  ActionMailer::Base.smtp_settings = {
      :address              => "localhost",
      :enable_starttls_auto => false
  }
  ACTION_MAILER_SETUP
end

gsub_file('app/models/feedback.rb',  'class Feedback < ApplicationRecord', 'class Feedback')

insert_into_file "app/models/feedback.rb", after: "class Feedback\n" do
  <<-FEEDBACK_MAILER
  include ActiveModel::Model
  attr_accessor :full_name, :email, :topic, :comment
  validates :email, :topic, :comment, presence: true
  validates_format_of :email,:with => /\A[^@\s]+@([^@\s]+\.)+[^@\s]+\z/, message: 'not a proper email address'
  FEEDBACK_MAILER
end

rails_command('g controller Feedbacks --no-test-framework --no-helper --no-assets --no-template-engine')

insert_into_file 'config/routes.rb', before: 'end' do
  <<-FEEDBACK_ROUTE
  resources 'feedbacks', only: [:create]
  FEEDBACK_ROUTE
end

insert_into_file "app/controllers/feedbacks_controller.rb", after: "ApplicationController\n" do
  <<-FEEDBACKS_CONTROLLER
  def create
   @feedback = Feedback.new feedback_params

   if @feedback.valid?
     FeedbackMailer.send_feedback(@feedback).deliver_now
     redirect_back(fallback_location: root_path, notice: "feedback received, thanks!")
   else
     redirect_back(fallback_location: root_path, notice: "There was an issue with your submission!")
   end
  end

  private

  def feedback_params
   params.require(:feedback).permit(:email, :topic, :comment)
  end

  FEEDBACKS_CONTROLLER
end

rails_command('g mailer Feedback')

insert_into_file 'app/mailers/feedback_mailer.rb', after: 'ApplicationMailer' do

  <<-FEEDBACKS_MAILER

  def send_feedback(message)
    @body = "Hi Dave"
    mail to: 'dschmura@humbledaisy.com'
  end

  FEEDBACKS_MAILER
end

# IF BOOTSTRAP??
file 'app/views/feedback/_feedback.html.haml'
  append_to_file 'app/views/feedback/_feedback.html.haml' do
    <<-BOODSTRAP_FEEDBACK_MODAL
/ Button trigger modal
%button.btn.btn-primary{"data-target" => "#contact-mailer--modal", "data-toggle" => "modal", :type => "button"}
  Feedback
/ Modal
#contact-mailer--modal.modal.fade.bd-example-modal-md{"aria-hidden" => "true", "aria-labelledby" => "contact-mailer--modalLabel", :role => "dialog", :tabindex => "-1"}
  .modal-dialog.modal-md{:role => "document"}
    .modal-content
      .modal-header
        %h4.modal-title Submit Your Feedback
        %button.close{"aria-label" => "Close", "data-dismiss" => "modal", :type => "button"}
          %span{"aria-hidden" => "true"} ×
      .modal-body
        = form_with model: @feedback do |f|
          .form-group
            = notice
            = @feedback.errors.full_messages.join(', ')
          .form-group
            = f.label :full_name, 'Full name', :class => "control-label"
            #form_div
              = f.text_field :full_name, placeholder: 'Full Name'
          .form-group
            = f.label :email, 'eMail', :class => "control-label"
            #form_div
              = f.email_field :email, placeholder: 'email@somewhere.com', required: true
          .form-group
            = f.label :topic, 'Topic', :class => "control-label"
            #form_div
              = f.select(:topic, options_for_select([['I have some feedback...','feedback'],['I have a question...', 'question'],['I have a feature request...','feature'],['I’d like to report a bug...','bug'],['Other','other']],1))
          .form-group
            = f.label :comment, 'Comment', :class => "control-label"
            #form_div
              = f.text_area :comment, placeholder: 'Comment', required: true
          .form-group
            #form_div
              = f.submit :submit, :controller => "messages", :action => "create", :class => "btn btn-success"

    BOODSTRAP_FEEDBACK_MODAL
    end


# append_to_file 'layouts/_footer.rb' do
#   <<-FEEDBACK_LINK
#   %br
#   = render 'feedback/feedback'
#   FEEDBACK_LINK
# end


file 'app/views/feedback_mailer/send_feedback.html.haml'
file 'app/views/feedback_mailer/send_feedback.text.haml'



insert_into_file 'app/controllers/application_controller.rb', after: "class ApplicationController < ActionController::Base\n" do
  <<-CONTROLLER_ACTION
  before_action :create_feedback

  private
  def create_feedback
    @feedback = Feedback.new
  end
  CONTROLLER_ACTION

end
