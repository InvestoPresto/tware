module Tware
  class TwitterUser
    attr_reader :authentication

    def initialize(user)
      @authentication = user.authentications.where(:provider => 'twitter').first if user.authentications
    end

    def new? # has_no_oauth_token
      authentication.nil?
    end

    def post_tweet(twitter_message)
      Twitter.configure do |config|
        config.consumer_key       = ENV['TWITTER_CONSUMER_KEY']
        config.consumer_secret    = ENV['TWITTER_CONSUMER_SECRET']
        config.oauth_token        = oauth_token
        config.oauth_token_secret = oauth_secret
      end

      Twitter.update(twitter_message)
    end

    private
    def oauth_token
      authentication.token_data['token']
    end

    def oauth_secret
      authentication.token_data['secret']
    end
  end
end
