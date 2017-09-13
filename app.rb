require 'sinatra'
require 'mail'
require 'aws-sdk'
set :port, 80
load "./local_env.rb" if File.exists?("./local_env.rb")

Mail.defaults do
  delivery_method :smtp,
  address: "email-smtp.us-west-2.amazonaws.com",
  port: 587,
  :user_name  => ENV['a3smtpuser'],
  :password   => ENV['a3smtppass'],
  :enable_ssl => true
end


get '/' do

erb :index
end

post '/' do

erb :index
end

get '/index' do

erb :index
end

post '/index' do

erb :index
end

get '/contact' do
    if params[:email]
        puts "true"
        thanksmessage = params[:email] + "'s email sent successfully, thanks for contacting me!"
    else
        puts "false"
        thanksmessage = ''
    end

erb :contact, :locals=>{:thanksmessage=> thanksmessage}
end

post '/contact' do
    thanksmessage = params[:thanksmessage]
    firstname = params[:fname]
    lastname = params[:lname]
    email= params[:email]
    message = params[:message]
    subject= params[:subject]
    email_body = erb(:email,:layout=>false, :locals=>{:fnmae => firstname, :lname => lastname, :email => email, :subject => subject, :message => message})

    mail = Mail.new do
      from         ENV['from']
      to           ENV['from']
      bcc          ENV['from']
      subject      subject

      html_part do
        content_type 'text/html'
        body         email_body
      end
    end

    mail.deliver!
    redirect '/contact?email=' + email
      
erb :contact, :locals => {:thanksmessage => thanksmessage, :email => email}
end