class PostsController < ApplicationController
	def create
		@user = current_user
		@post = Post.create(content: user_params[:content], user_id: current_user.id, latitude: user_params[:latitude], longitude: user_params[:longitude])
		@post.save

		#The following posts to the user's Facebook wall
		@user.facebook.put_wall_post(@post.content)

		redirect_to root_path
	end

	private

  	def user_params
    	params.require(:post).permit(:content, :user_id, :latitude, :longitude)
  	end
end
