rails_command("generate model ContactMessage --no-migration --no-fixture")
rails_command("generate mailer ContactMessage")


gsub_file('app/models/contact_message.rb',  'class ContactMessage < ApplicationRecord', 'class ContactMessage')


insert_into_file "app/models/contact_message.rb", after: "class ContactMessage\n" do
  <<-CONTACT_MAILER
  include ActiveModel::Model
  attr_accessor :name, :email, :body
  validates :name, :email, :body, presence: true

  CONTACT_MAILER
end

rails_command('generate controller contact_messages --no-helper --no-assets')

insert_into_file 'config/routes.rb', before: 'end' do
  <<-CONTACT_MAILER_ROUTE
  get 'contact', to: 'contact_messages#new', as: 'new_message'
  CONTACT_MAILER_ROUTE
end


insert_into_file "app/controllers/contact_messages_controller.rb", after: "ApplicationController\n" do
  <<-CONTACT_MAILER_CONTROLLER
  def new
    @contact_message = ContactMessage.new
  end
  CONTACT_MAILER_CONTROLLER

end

