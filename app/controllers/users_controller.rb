class UsersController < ApplicationController

      get '/signup' do
        if !current_user
          erb :'users/create_user'
        else
          redirect to "/tweets"
        end
      end
    
      post '/signup' do
        if params[:username] == "" || params[:email] == "" || params[:password] == ""
          redirect '/signup'
        else
          @user = User.create(params[:user])
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
        user = User.find_by(username: params[:user][:username])
        if user && user.authenticate(params[:user][:password])
          session[:user_id] = user.id
          redirect "/tweets"
        else
          redirect 'users/signup'
        end
      end

      get '/users/:slug' do
        if current_user
          @user = User.find_by_slug(params[:slug])
          @tweets = Tweet.all
          erb :"users/#{@user.slug}"
        else
          redirect '/login'
        end
      end
    
end
