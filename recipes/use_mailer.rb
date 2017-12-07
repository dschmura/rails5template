rails_command("generate model ContactMessage --no-migration --no-fixture")
rails_command("generate mailer ContactMessage")


gsub_file('app/models/contact_message.rb',  'class ContactMessage < ApplicationRecord', 'class ContactMessage')


insert_into_file "app/models/contact_message.rb", after: "class ContactMessage\n" do
  <<-CONTACT_MAILER
  include ActiveModel::Model
  attr_accessor :name, :email, :body
  validates :name, :email, :body, presence: true
  validates_format_of :email,:with => /\A[^@\s]+@([^@\s]+\.)+[^@\s]+\z/,message: 'not a proper email address'
  CONTACT_MAILER
end

rails_command('generate controller ContactMessages new create --no-test-framework --no-helper --no-assets --no-template-engine')

gsub_file('config/routes.rb',  "get 'contact_messages/new'\n  get 'contact_messages/create'", "")

insert_into_file 'config/routes.rb', before: 'end' do
  <<-CONTACT_MAILER_ROUTE
  get 'contact', to: 'contact_messages#new', as: 'new_message'
  CONTACT_MAILER_ROUTE
end


insert_into_file "app/controllers/contact_messages_controller.rb", after: "ApplicationController\n" do
  <<-CONTACT_MAILER_CONTROLLER
  class ContactMessagesController < ApplicationController

   def create
      @contact_message = ContactMessage.new contact_message_params

     if @contact_message.valid?
        ContactMessageMailer.send_contact_message(@contact_message).deliver_now
        redirect_to room_path, notice: “Message received, thanks!”
      else
        redirect_back(fallback_location: root_path, notice: “There was a problem submitting your message.“)
      end
    end

   private

   def contact_message_params
      params.require(:contact_message).permit(:name, :email, :body)
    end
  end
  CONTACT_MAILER_CONTROLLER

end

rails_command('generate mailer ContactMessageMailer')

insert_into_file 'contact_message_mailer', after: 'class ContactMessageMailer < ApplicationMailer\n' do
  <<-CONTACT_MAILER_MAILER
  layout 'contact_mailers/send_contact_mailer'

  def send_contact_mailer(message)
    @body = “Topic: #{message.topic} \nComment: #{message.comment} ”
    mail to: “dschmura@humbledaisy.com”, from: message.email
  end
  CONTACT_MAILER_MAILER
end
