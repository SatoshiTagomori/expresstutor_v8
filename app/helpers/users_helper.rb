module UsersHelper
    def current_user
        if @current_user.nil?
            @current_user = LineUser.find_by(:line_id=>session[:line_act_sub])
        else
            @current_user 
        end
    end
    
    def is_logined?
        current_user.present?
    end
    
    def is_admin?
       current_user.present? && current_user.admin==true 
    end
    
    def redirect_if_not_admin
       if is_admin? == false then redirect_to root_path end 
    end
    
    def redirect_if_not_logined
       if is_logined? == false then redirect_to root_path end 
    end
    
    def authorize
       @current_user = current_user 
    end
    
    def redirect_back_if_not_admin
       redirect_to root_path and return unless is_admin?
    end
    

end
