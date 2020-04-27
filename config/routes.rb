Rails.application.routes.draw do
  root to: 'link#index'
  get "/:slug", to: "link#show"
  get "link/:slug", to: "link#shortened", as: :shortened
  post "/link/create"
  get "/link/fetch_original_url"
end
