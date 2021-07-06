Rails.application.routes.draw do
  root 'home#index'
  get 'course'=>'home#course',as: :course
  
  #############ユーザー用画面##############
  get 'profile'=>'users#index',as: :profiles
  post 'profile'=>'users#create'
  patch 'profile'=>'users#update'
  get 'sign_out'=>'users#sign_out',as: :sign_out
  get 'profile/edit'=>'users#edit',as: :profile_edit

  #############api##########################
  get '/api/subscriptions'=>'api#subscriptions',as: :subscriptions
  get '/api/non_subscriptions'=>'api#non_subscriptions',as: :non_subscriptions
  
  ############支払い関連###############
  get '/payment'=>'users#payment',as: :payment
  #支払い成功
  #get '/payment/:course_id/succeeded/:session'=>'payments#payment_succeeded',as: :payment_succeeded
  get '/payment/subscription/succeeded/:session'=>'payments#payment_succeeded',as: :payment_succeeded
  #支払い失敗
  get '/payment/failed'=>'payments#payment_failed',as: :payment_failed
  #チェックアウトセッション
  post '/create_checkout_session'=>'payments#create_checkout_session',as: :checkout
  get 'tickets'=>'payments#get_tickets_from_price_id'
  post '/payment/delete/subscriptions'=>'payments#cancel_subscription'
  #支払いキャンセル
  post '/refund'=>'payments#refund',as: :refund
  post '/subscription/paied'=>'payments#subscription_paied',as: :subscription_paied
end
