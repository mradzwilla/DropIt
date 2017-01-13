class Authentication < ActiveRecord::Base
	belongs_to :user

	def password_required?
		puts "PASS for AUTH"
		super
	end
end
