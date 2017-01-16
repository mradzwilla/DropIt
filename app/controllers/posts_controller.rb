class PostsController < ApplicationController
	def create
		@user = current_user
		@provider = user_params[:provider]
		@post = Post.create(content: user_params[:content], user_id: current_user.id, latitude: user_params[:latitude], longitude: user_params[:longitude], provider: @provider)
		
		if @provider == 'facebook'
			#The following will post to user's Facebook and return the post id
			@post_id = @user.facebook.put_wall_post(@post.content)
			@post_id = @post_id['id']
			@post.update(external_id: @post_id)
		end

		if @provider == 'twitter'
			@post_id = @user.twitter.update(@post.content)
			puts @post_id
			@post.update(external_id: @post_id)
		end
		@post.save
		redirect_to root_path
	end

	private

  	def user_params
    	params.require(:post).permit(:content, :user_id, :latitude, :longitude, :provider)
  	end
end
