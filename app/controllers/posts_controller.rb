class PostsController < ApplicationController
	def create
		puts "whatever"
		puts current_user.id

		@user = current_user.fullname
		@post = Post.create(content: user_params[:content], user_id: current_user.id, latitude: user_params[:latitude], longitude: user_params[:longitude])
		puts user_params
		puts @post.id
		puts @post.user
		puts @post.content

		@post.save
		if @post.save
			puts "Success"
		else
			puts 'no Success'
		end

		redirect_to root_path
	end

	private

  	def user_params
    	params.require(:post).permit(:content, :user_id, :latitude, :longitude)
  	end
end
