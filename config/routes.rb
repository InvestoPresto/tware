Tware::Engine.routes.draw do
  post "/twitter_post", :to => "twitter#create"
end
