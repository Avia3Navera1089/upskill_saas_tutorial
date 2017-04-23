class ContactsController < ApplicationController
  
  # GET request to/contact-us
  # Show new contact form
  def new #checks out new.html.eb
    @contact = Contact.new #goes to contact.rb in models folder and validates stuff
  end
  # POST request /contacts
  def create
    # mass assignment of form fields into contact object
    @contact = Contact.new(contact_params)
    if @contact.save # saving to the database
      # storing form fields via params into variables
      name = params[:contact][:name]
      email = params[:contact][:email]
      body = params[:contact][:comments]
      # pluggingvariables into contact mailer and sending them
      ContactMailer.contact_email(name, email, body).deliver
      #storing success message in flash hash
      flash[:success] = "Message sent"
      redirect_to new_contact_path
    else
      flash[:danger] = @contact.errors.full_messages.join(", ")
      redirect_to new_contact_path
    end 
  end
  
  private
  #to collect data from form we need to use strong params and whitelist form fields
    def contact_params
      params.require(:contact).permit(:name, :email, :comments)
    end
end 