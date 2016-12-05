class HomeController < ApplicationController

	def signin
	  	if user_signed_in?
	  		redirect_to index_path
	  	else
	  		redirect_to new_user_session_path
	  	end 
	end

	def index
		@user = current_user
		@post = Post.new

		@user_latitude = current_user.latitude
		@user_longitude = current_user.longitude

		@nearby_posts = Post.near([@user_latitude, @user_longitude], 20)
		@all_posts = Post.geocoded

		@all_posts.each do |p|
			puts p.content
			puts p.distance_from([@user_latitude, @user_longitude])
		end
	end

	def updateUserCoordinates
		@user = current_user
		@post = Post.new

		@user_latitude = current_user.latitude
		@user_longitude = current_user.longitude
		@nearby_posts = Post.near([@user_latitude, @user_longitude], 20)

		@new_latitude = params['latitude']
		@new_longitude = params['longitude']
		current_user.update(:latitude => @new_latitude, :longitude => @new_longitude)
		
		puts "Updated Coordinates"
		render :template => "home/index"
		# redirect_to index_path
	end
end
