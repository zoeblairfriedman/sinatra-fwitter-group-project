class UsersController < ApplicationController

    
      get '/signup' do
        if current_user
          redirect "/tweets"
        end
        erb :'users/create_user'
      end
    
      post '/signup' do
        user = User.create(params[:user])
        if user.id
          session[:user_id] = user.id
          redirect "/tweets"
        else
          redirect "/signup"
        end
      end
    
      get '/logout' do
        session.clear
        redirect '/'
      end
    
      get '/login' do
        if session[:user_id]
          redirect "/users/#{session[:user_id]}"
        end
        erb :'users/login'
      end
    
      post '/login' do
        user = User.find_by(name: params[:user][:name])
        if user && user.authenticate(params[:user][:password])
          session[:user_id] = user.id
          redirect "/users/#{user.id}"
        else
          flash[:message] = "Incorrect username or password"
          redirect 'users/login'
        end
      end
    
end
