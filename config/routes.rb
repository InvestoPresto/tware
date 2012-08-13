Tware::Engine.routes.draw do
  match "/twitter_post", :to => "twitter#create"
end
