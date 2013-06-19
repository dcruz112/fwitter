class User < ActiveRecord::Base
	has_many :tweets



	validates :handle, uniqueness: { case_sensitive: false }
	# validates :handle, format: { with: /\A[@][a-zA-Z0-9_]+\z/,
 	# message: "Handle should start with '@' and conclude with only letters, numbers, and '_'" }
	
	validates :handle, format: { with: /\A[a-zA-Z0-9_]+\z/,
    message: "Only use letters, numbers, and '_'" }



	def handle_at
		"@" + handle
	end
	
	def full_name
		first_name + " " + last_name
	end
end
