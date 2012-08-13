module Tware
  class TwitterController < ApplicationController
    def create
      if current_user.nil?
        #raise error for not logged in user
      end
      if has_twitter_provider?
        # ck = 'GFFg7dijkW8HFuUaKMw'
        # cs = '1CGVVubQJCeCz8qKQyLdhRnKrUWbbPvc2OMLbHExNI'
        Twitter.configure do |config|
          config.consumer_key = ENV['TWITTER_CONSUMER_KEY']
          config.consumer_secret = ENV['TWITTER_CONSUMER_SECRET']
          config.oauth_token = user_twitter_oauth_token
          config.oauth_token_secret = user_twitter_oauth_secret
        end
        Twitter.update(params[:twitter][:message])
        redirect_to  params[:redirect_uri]
      else
        redirect_to "/auth/twitter?origin=/twitter_post?redirect_uri=#{params[:redirect_uri]}"
      end
    end

    private
    def has_twitter_provider?
      twitter_authentication.present?
    end

    def user_twitter_oauth_token
      twitter_authentication.token_data['token']
    end

    def user_twitter_oauth_secret
      twitter_authentication.token_data['secret']
    end

    def twitter_authentication
      current_user.authentications.where(:provider => 'twitter').first
    end

    # def check?
    #   # if current_user && current_user.has_twitter_provider?
    #   return true unless session[:user_id]
    #   user = User.find(session[:user_id])
    #   return true unless user.has_twitter_provider?
    # end
  end
end