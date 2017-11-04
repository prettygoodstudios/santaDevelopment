Rails.application.routes.draw do
  devise_for :users, path: '', path_names: {sign_in: 'login', sign_out: 'logout', sign_up: "register"}
  root to: "page#index"
  resources "family"
  resources "item"
  post "/update_item", to: "item#update_status"
  get "/user/", to: "user#show"
  get "/add_family/:id", to: "family#add_family"
  get "/remove_family/:id", to: "family#remove_family"
  get "/admin", to: "page#admin"
  get "/family_api", to: "family#api"
  get "/contact/:id", to: "page#contact"
  get "/donor/:id", to: "page#donor"
  get "/my_family/:id", to: "family#my_family"
  get "/family_admin/:id", to: "family#family_admin"
  get "/sendemail/:id", to: "page#sendEmail"
  get "/landing", to: "page#landing"
  get "/contact_alert", to: "page#alert_user"
  get "/verify/:id", to: "user#verify"
  post "/checkToken/:id", to: "user#checkToken"
  post "/remove_status", to: "item#remove_status"
  post "/recieved", to: "item#recieved"
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
