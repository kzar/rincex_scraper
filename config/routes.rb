Scraper::Application.routes.draw do
  get "/" => "items#index"
  get "/feed-#{Item.first.id}.atom" => "items#feed", :format => 'atom'
  get "/feed-#{Item.first.id}-:internal.atom" => "items#feed", :format => 'atom', :internal => /internal/
end
