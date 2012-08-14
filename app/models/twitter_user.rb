class TwitterUser
  attr_reader :user

  def initialize(user)
    @user = user
  end

  def new?
    twitter_authentication.nil?
  end

  def post_tweet_on_twitter(twitter_message)
    Twitter.configure do |config|
      config.consumer_key = ENV['TWITTER_CONSUMER_KEY']
      config.consumer_secret = ENV['TWITTER_CONSUMER_SECRET']
      config.oauth_token = user_twitter_oauth_token
      config.oauth_token_secret = user_twitter_oauth_secret
    end

    Twitter.update(twitter_message)
  end

  private
  def twitter_authentication
    if user.authentications
      user.authentications.where(:provider => 'twitter').first
    end
  end

  def user_twitter_oauth_token
    twitter_authentication.token_data['token']
  end

  def user_twitter_oauth_secret
    twitter_authentication.token_data['secret']
  end
end