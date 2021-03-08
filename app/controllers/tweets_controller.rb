class TweetsController < ApplicationController

    get '/tweets' do
        if logged_in?
          @tweets = Tweet.all
          erb :'tweets/tweets'
        else
          redirect to '/login'
        end
      end

      get '/tweets/new' do
        if logged_in?
          @user = current_user
          erb :'tweets/create_tweet'
        else
          redirect to '/login'
        end
      end

      post '/tweets' do
        if params[:content] != ""
            @user = current_user
            new_tweet = Tweet.create(content: params[:content], user_id: @user.id)
            @user.tweets << new_tweet
            @tweets = Tweet.all
            erb :'tweets/tweets'
        else
            redirect '/tweets/new'
        end
    end

    get '/tweets/:id' do
        if logged_in?
            @tweet = Tweet.find_by(id: params[:id])
            erb :"/tweets/show_tweet"
        else
            redirect '/login'
        end
    end

    get '/tweets/:id/edit' do
        @tweet = Tweet.find_by(id: params[:id])
        @tweets = Tweet.all
        if logged_in? && @current_user == @tweet.user
            erb :"/tweets/edit_tweet"
        else
            redirect '/login'
        end
    end

    patch '/tweets/:id' do 
        @tweet = Tweet.find_by(id: params[:id])
        if params[:content] != ""
            @tweet.update(content: params[:content])
            @tweets = Tweet.all
            erb :'tweets/tweets'
        else
            redirect "/tweets/#{@tweet.id}/edit"
        end
    end

    delete '/tweets/:id/delete' do
        @tweet = Tweet.find_by(id: params[:id])
        if logged_in? && @current_user == @tweet.user
            @tweet.delete
            @tweets = Tweet.all
            erb :'tweets/tweets'
        else
            redirect '/login'
        end
    end

end
