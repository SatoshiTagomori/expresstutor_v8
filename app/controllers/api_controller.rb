class ApiController < ApplicationController
    def subscriptions
       render json: Course.where(:status=>true,:subscription=>true) 
    end
    
    def non_subscriptions
       render json: Course.where(:status=>true,:subscription=>false) 
    end
    
end
