class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
 	devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :omniauthable, :omniauth_providers => [:facebook, :twitter]

	has_many :posts
	has_many :authentications

	def self.from_omniauth(auth, current_user)
	  authorization = Authentication.where(:provider => auth.provider, :uid => auth.uid.to_s, 
	                                      :token => auth.credentials.token, 
	                                      :secret => auth.credentials.secret).first_or_initialize

	  #This is trying to save the profile URL. We should do that later via koala
	  # authorization.profile_page = auth.info.urls.first.last unless authorization.persisted?
	  puts "Top of controller"
	  #Twitter only provides email via API with elevated permissions
	  if authorization.user.blank? && auth.provider == 'facebook'

		@koala = Koala::Facebook::API.new(auth.credentials.token)
	   	@user_info = @koala.get_object(:me, { fields: [:first_name, :last_name, :email]})

		user = current_user.nil? ? User.where('email = ?', @user_info['email']).first : current_user

	    if user.blank?
	      user = User.new
	      user.password = Devise.friendly_token[0, 20]
          user.first_name = @user_info['first_name']
          user.last_name = @user_info['last_name']
          user.email = @user_info['email']
          user.oath_relationship = true
	      user.save
	    end
	    authorization.user = user
	    authorization.save
	  end
	  
	  if authorization.user.blank? && auth.provider == 'twitter'
	  	@uid = auth.uid
	  	@existing_record = Authentication.where(:provider => 'twitter', :uid => @uid).first
	  	@user_record = @existing_record.blank? ? User.new : @existing_record.user
	  	user = current_user.nil? ? @user_record : current_user
	  	if user.new_record?
	  	  user.password = Devise.friendly_token[0, 20]
	  	  user.oath_relationship = true
	  	  #Twitter only returns full name
	  	  @fullname = auth['info']['name'].split(' ')
	  	  user.first_name = @fullname[0]
	  	  user.last_name = @fullname[1]
	      authorization.save
	      user.authentications << authorization
	      user.save
	  	else
	      authorization.user = user
	      authorization.save
	   end
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
		#Will return false if oath_relationship exists
		super && (oath_relationship == false)
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
		@oauth_token = authentications.where(:provider => 'facebook').first.token
		Koala::Facebook::API.new(@oauth_token)
	end

	def twitter
		@oauth_credentials = authentications.where(:provider => 'twitter').first
		client = Twitter::REST::Client.new do |config|
		  config.consumer_key        = ENV["TWITTER_ID"]
		  config.consumer_secret     = ENV["TWITTER_SECRET"]
		  config.access_token        = @oauth_credentials.token
		  config.access_token_secret = @oauth_credentials.secret
		end
	end
end
