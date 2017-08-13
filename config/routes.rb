Rails.application.routes.draw do
  get 'search/index'
  post "videos_Search" => "search#videos_Search", as: :videos_Search
  root to:'search#index'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
