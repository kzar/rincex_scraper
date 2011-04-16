Scraper::Application.routes.draw do
  get "/" => "items#index"
  get "/feed-#{Item.first.id}.atom" => "items#feed", :format => 'atom'
end
