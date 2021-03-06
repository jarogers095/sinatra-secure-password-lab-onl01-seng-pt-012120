require "./config/environment"
require "./app/models/user"
class ApplicationController < Sinatra::Base

  configure do
    set :views, "app/views"
    enable :sessions
    set :session_secret, "password_security"
  end

  get "/" do
    erb :index
  end

  get "/signup" do
    erb :signup
  end

  post "/signup" do
    new_user = User.new(username: params[:username], password: params[:password], balance: 0.0)
    
    if new_user.username != "" && new_user.save
      redirect "/login"
    else
      redirect "/failure"
    end
  end

  get '/account' do
    @user = current_user
    erb :account
  end
  
  post "/account" do
    @user = current_user
    if params[:deposit] && params[:amount].to_f > 0
      @user.deposit(params[:amount].to_f)
    elsif params[:withdrawal] && params[:amount].to_f > 0
      @user.withdraw(params[:amount].to_f)
    end
    
    erb :account
  end


  get "/login" do
    erb :login
  end

  post "/login" do
    user = User.find_by(username: params[:username])
    
    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      redirect "/account"
    else
      redirect "/failure"
    end
  end

  get "/failure" do
    erb :failure
  end

  get "/logout" do
    session.clear
    redirect "/"
  end

  helpers do
    def logged_in?
      !!session[:user_id]
    end

    def current_user
      User.find(session[:user_id])
    end
  end
end
