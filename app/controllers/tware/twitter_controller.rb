module Tware
  class UnAuthorizedException < StandardError; end

  class TwitterController < ApplicationController
    before_filter :authorize_user

    def create
      store_params_in_session
      twitter_user = TwitterUser.new(current_user)

      if twitter_user.new?
        redirect_to "/auth/twitter?origin=/twitter_post"
      else
        begin
          twitter_user.post_tweet(session[:twitter_message])
          redirect_url = get_redirect_url('You have successfully tweeted the link', 'notice')
        rescue Twitter::Error::Forbidden => e
          redirect_url = get_redirect_url(e.message, 'error')
        ensure
          clear_session!(:twitter_message, :step, :return_to)
          redirect_to redirect_url
        end
      end
    end

    private
    def authorize_user
      redirect_to get_redirect_url('Please Login before you perform this action', 'error') if current_user.nil?
    end

    def store_params_in_session
      session[:step] ||= params[:step]
      session[:twitter_message] ||= params[:twitter_message]
      session[:return_to] ||= params[:return_to]
    end

    def clear_session!(*args)
      args.each {|arg| session[arg] = nil}
    end

    def get_redirect_url(msg, msg_type)
      "#{twitter_callback}?#{query_params(msg, msg_type)}"
    end

    def query_params(message, message_type)
      {
        :return_to => session[:return_to],
        :msg => message,
        :type => message_type,
        :step => session[:step]
      }.to_query
    end

    def twitter_callback
      'http://localhost:3000/social_network/twitter_callback'
    end
  end
end