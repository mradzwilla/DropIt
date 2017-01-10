class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
 	devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :omniauthable, :omniauth_providers => [:facebook, :twitter]

	has_many :posts
	
	def self.from_omniauth(auth)
	      where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
	      	@provider = auth.provider
	        user.provider = @provider
	        user.uid = auth.uid
	        user.password = Devise.friendly_token[0,20]
	        user.first_name = auth.name
	        
	        if @provider == 'facebook'
		        user.oauth_token = auth.credentials.token
		        user.oauth_expires_at = Time.at(auth.credentials.expires_at)
		        @user_info = user.facebook.get_object(:me, { fields: [:first_name, :last_name, :email]})
		        user.first_name = @user_info['first_name']
		        user.last_name = @user_info['last_name']
		        user.email = @user_info['email']
		    end

	     end
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
