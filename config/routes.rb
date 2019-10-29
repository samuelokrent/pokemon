Rails.application.routes.draw do

  root to: "games#home"

  resources :games do
    member do
      get 'pick_deck'
      get 'choose'
      post 'answer_mega_question'
      get 'battle'
    end
  end


  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
