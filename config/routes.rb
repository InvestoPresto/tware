Tware::Engine.routes.draw do
  get "/twitter_post", :to => "twitter#create"
end
