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

		@nearbyInfo = []
		@nearby_posts.each do |post|
			@nearbyInfo.push({
				content: post.content,
				postLatitude: post.latitude,
				postLongitude: post.longitude,
				user: post.user.fullname,
				timestamp: post.created_at
			})
		end

		gon.push({
			nearbyPosts: @nearby_posts
		})
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
