class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
 	devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :omniauthable, :omniauth_providers => [:facebook, :twitter]

	has_many :posts
	has_many :authorizations
	
	# SOCIALS = {
	# 	facebook: 'Facebook',
	# 	twitter: 'Twitter'
	# }

	def self.from_omniauth(auth, current_user)
	  authorization = Authentication.where(:provider => auth.provider, :uid => auth.uid.to_s, 
	                                      :token => auth.credentials.token, 
	                                      :secret => auth.credentials.secret).first_or_initialize

	  #This is trying to save the profile URL. We should do that later via koala
	  # authorization.profile_page = auth.info.urls.first.last unless authorization.persisted?
	  
	  #Twitter only provides email via API with elevated permissions
	  if authorization.user.blank? && :provider != 'twitter'

		@koala = Koala::Facebook::API.new(auth.credentials.token)
	   	@user_info = @koala.get_object(:me, { fields: [:first_name, :last_name, :email]})

		user = current_user.nil? ? User.where('email = ?', @user_info['email']).first : current_user

	    if user.blank?
	      user = User.new
	      user.password = Devise.friendly_token[0, 20]
          user.first_name = @user_info['first_name']
          user.last_name = @user_info['last_name']
          user.email = @user_info['email']
	      user.save
	    end
	    authorization.user = user
	    authorization.save
	  end
	  authorization.user
	end

	def self.new_with_session(params, session)
		if session["devise.user_attributes"]
			new(session["devise.user_attributes"], without_protection: true) do |user|
				user.attributes = params
				user.valid?
			end
		else
			super
		end
	end

	def password_required?
		super && provider.blank?
	end

	def update_with_password(params, *options)
		if encrypted_password.blank?
			update_attributes(params, *options)
		else
			super
		end
	end

	def fullname
		"#{first_name} #{last_name}"
	end

	def facebook
		Koala::Facebook::API.new(oauth_token)
	end

end
