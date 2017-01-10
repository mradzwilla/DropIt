class CallbacksController < Devise::OmniauthCallbacksController

    def all
    	puts request.env["omniauth.auth"]
        puts request.env["omniauth.auth"]['provider']
    	# raise request.env["omniauth.auth"]['credentials']['token'].to_yaml

    	@user = User.from_omniauth(request.env["omniauth.auth"])
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
