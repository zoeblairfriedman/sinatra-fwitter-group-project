class UsersController < ApplicationController
      
      get '/users/:slug' do
        if logged_in?
          @user = User.find_by_slug(params[:slug])
          @user_tweets = @user.tweets
          erb :'users/show'
        else
          redirect '/login'
        end
      end

      get '/signup' do
        if !logged_in?
          erb :'users/create_user'
        else
          redirect to "/tweets"
        end
      end
    
      post '/signup' do
        if params[:username] == "" || params[:email] == "" || params[:password] == ""
          redirect '/signup'
        else
          @user = User.create(username: params[:username], email: params[:email], password: params[:password])
          session[:user_id] = @user.id
          redirect to '/tweets'
        end
      end
    
      get '/logout' do
        session.clear
        redirect '/login'
      end

    
      get '/login' do
        if !current_user
          erb :'users/login'
        else
          redirect to "/tweets"
        end
      end
    
      post '/login' do
        user = User.find_by(username: params[:username])
        if user && user.authenticate(params[:password])
          session[:user_id] = user.id
          redirect "/tweets"
        else
          redirect '/users/signup'
        end
      end


    
end
