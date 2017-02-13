Rails.application.routes.draw do
  get 'game',  to: 'game#game'
  get 'score', to: 'game#score'
end
