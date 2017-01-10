class CallbacksController < Devise::OmniauthCallbacksController

    def all
        @current_user = current_user

    	@user = User.from_omniauth(request.env["omniauth.auth"], @current_user)
    	@request = request.env["omniauth.auth"]

    	if @user.persisted?
    		flash.notice = "You have successfully signed in!"
    		sign_in_and_redirect @user
    	else
    		session["devise.user_attributes"] = @user.attributes
			redirect_to new_user_registration_path    	
		end
    end

    alias_method :facebook, :all
    alias_method :twitter, :all

end
