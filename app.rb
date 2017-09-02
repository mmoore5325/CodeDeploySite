
require 'sinatra'
require 'pony'
require 'pg'
require 'rubygems'
require 'bundler/setup'
require 'recaptcha'
load "./local_env.rb" if File.exists?("./local_env.rb")

enable :sessions

def db_conn_1()
  db_params = {
    host: ENV['host'],
    port: ENV['port'],
    dbname: ENV['dbname'],
    user: ENV['user'],
    password: ENV['password']
  }
  PG::Connection.new(db_params)
end

def db_conn_2()
  db_params = {
    host: ENV['host2'],
    port: ENV['port2'],
    dbname: ENV['dbname2'],
    user: ENV['user2'],
    password: ENV['password2']
  }
  PG::Connection.new(db_params)
end

def authentication_required
  redirect to('/') unless session[:user]
end

def send_email(details)
  Pony.mail(
    :to => details[:email],
    :bcc => 'joseph.p.mckenzie@gmail.com', 
    :from => 'joseph.p.mckenzie@gmail.com',
    :subject => "Joseph Mckenzie Consulting  #{details[:reason]}", 
    :content_type => 'text/html', 
    :body => erb(:email,:layout=>false, locals: {details: details}),
    :via => :smtp, 
    :via_options => {
      :address              => 'smtp.gmail.com',
      :port                 => '587',
      :enable_starttls_auto => true,
       :user_name           => ENV['email'],
       :password            => ENV['email_pass'],
       :authentication       => :plain, 
       :domain               => ENV['domain'] 
    }
  )
end
class MyApp < Sinatra::Base
 set :run, true

set :bind, '0.0.0.0'
set :port, 80
 
get '/' do
  @title = "Joseph Mckenizie Consulting"
  message = params[:message] || ''
  messages = {'' => '', '404' => "Sorry, the page you are looking for doesn't exist", 'added' => 'Thanks, for joining our mailing list.', 'exists' => 'You have already joined our mailing list'}
	erb :index, :locals => {:message => messages[message]}
end

get '/consultancy' do
  @title = 'Consultancy'
  num1 = rand(9)
  num2 = rand(9)
  sum = num1 + num2
	erb :consultancy, :locals => {:num1 => num1, :num2 => num2, :sum => sum }
end

get '/meetme' do
  @title = 'Meet the man'
	erb :meetme
end

post '/register' do

  first_name = params[:first_name]
  last_name = params[:last_name]
  city = params[:city]
	state = params[:state]
	zip = params[:zip]
	email_address = params[:email_address]
	phone = params[:phone]
	hackerscore = params[:hackerscore]
	mailinglist = params[:mailinglist]
	service = params[:service]
  robot = params[:robot]
  sum = params[:sum]

  db = db_conn_1()
  check_email = db.exec("SELECT * FROM public.training WHERE email = '#{email_address}'")

  if robot == sum && check_email.num_tuples.zero?
    Pony.mail(
      :to => email_address,
      :bcc => 'joseph.p.mckenzie84@gmail.com', 
      :from => 'joseph.p.mckenzie84@gmail.com',
      :subject => "Joseph Mckenzie Consulting Training (#{service})", 
      :content_type => 'text/html', 
      :body => erb(:training_email,:layout=>false),
      :via => :smtp, 
      :via_options => {
        :address              => 'smtp.gmail.com',
        :port                 => '587',
        :enable_starttls_auto => true,
         :user_name           => ENV['email'],
         :password            => ENV['email_pass'],
         :authentication       => :plain, 
         :domain               => ENV['domain'] 
      }
    ) 

	  db.exec("INSERT INTO public.training (first_name, last_name,city, state, zip, email, phone, service, hackerscore) VALUES('#{first_name}', '#{last_name}', '#{city}', '#{state}', '#{zip}', '#{email_address}', '#{phone}','#{service}','#{hackerscore}')")
    db.close
    
    mailing_db = db_conn_1()
    check_email = mailing_db.exec("SELECT * FROM mailing_list WHERE email = '#{email_address}'")
    if check_email.num_tuples.zero? && mailinglist == "add"
      mailing_db.exec("INSERT INTO mailing_list (email) VALUES ('#{email_address}');")
    end
    mailing_db.close

	  redirect '/training?message=register'
  else
    db.close
    redirect '/training?message=error' 
  end
end

get '/contact' do
  @title = 'Contact'
  deliver = params[:deliver] || ''
  messages = {'' => '', 'success' => "Thank you for your message. We'll get back to you shortly.", 'error' => 'Sorry, there was a problem delivering your message.'}
  message = messages[deliver]
  num1 = rand(9)
  num2 = rand(9)
  sum = num1 + num2
	erb :contact, :locals => {:message => message, :num1 => num1, :num2 => num2, :sum => sum }
end

post '/contact' do
  name = params[:name]
  phone = params[:phone]
  email = params[:email]                  
  message = params[:message]
  reason = params[:reason]
  mailinglist = params[:mailinglist]
  robot = params[:robot]
  sum = params[:sum]
  
  if robot == sum
    send_email({reason: reason, name: name, phone: phone, email: email, message: message})
    db = db_conn_1()
    check_email = db.exec("SELECT * FROM mailing_list WHERE email = '#{email}'")

    if mailinglist == "add" && check_email.num_tuples.zero? == true
      subscribe=db.exec("INSERT INTO mailing_list (email) VALUES ('#{email}');")
    end
    db.close
    redirect '/contact?deliver=success'
  else
    redirect '/contact?deliver=error'
  end
end 

get '/login' do
  erb :login, :locals => {:message => ""}
end

post '/login' do
  user = params[:user]
  pass = params[:password]
  
  if user == ENV['login_username'] && pass == ENV['login_password']
    session[:user] = user
    redirect to('/send_emails')
  else  
    erb :login, :locals => {:message => "invalid username / password combination"}
  end
end

get '/logout' do
 session[:user] = nil
 redirect '/'
end

get '/send_emails' do
  authentication_required
  message = params[:message] || ""
  db = db_conn_1()
  subscribers = db.exec("select email from mailing_list")
  db.close
  erb :subscribers, :locals => {:subscribers => subscribers, :message => message}
end 

post '/send_mail_to_list' do
      subject = params[:subject]
      email_list = params[:email]
      message = params[:message]
      
    Pony.mail(
        :to => '',
        :bcc => email_list,
        :from => 'joseph.p.mckenzie84@gmail.com',
        :subject => "#{subject}", 
        :content_type => 'text/html', 
        :body => erb(:send_mailer,:layout=>false,:locals=>{:subject => subject,:message => message}),
        :via => :smtp, 
        :via_options => {
          :address              => 'smtp.gmail.com',
          :port                 => '587',
          :enable_starttls_auto => true,
           :user_name           => ENV['email'],
           :password            => ENV['email_pass'],
           :authentication       => :plain, 
           :domain               => ENV['domain'] 
        }
      )

    message = "Message-sent"
    redirect '/send_emails?message=' + message
end 
#
get '/support' do
  @title = 'Support'
	erb :support
end

#get '/donate' do
#  redirect 'support'
#end
#
#get '/overview' do
#  redirect 'training'
#end
#
post '/subscribe' do
  email = params[:email]
  db =db_conn_1()
  check_email = db.exec("SELECT * FROM mailing_list WHERE email = '#{email}'")
     
  if check_email.num_tuples.zero? == false
    db.close
    redirect '/?message=exists'
  else
    subscribe=db.exec("INSERT INTO mailing_list (email) VALUES ('#{email}');")
    db.close
    redirect '/?message=added'
  end
end
#
#get '/news' do
#    @title = 'News'
#    erb :news
#end
#
#get '/thanks' do
#  erb :thanks
#
#end
#
get '/training' do
  @title = 'Training'
  num1 = rand(9)
  num2 = rand(9)
  sum = num1 + num2
	message = params[:message] || ''
	messages = {'' => '','register' => 'Thanks for registering your interest in joining my training.', 'error' => "It looks like you're a robot!"}
  erb :training, :locals => {:message => messages[message], :num1 => num1, :num2 => num2, :sum => sum}
end
#
#get '/foundation' do
#  @title = 'Foundation'
#  num1 = rand(9)
#  num2 = rand(9)
#  sum = num1 + num2
#  erb :foundation, :locals => {:num1 => num1, :num2 => num2, :sum => sum }
#end


not_found do
  redirect '/?message=404'
end

end