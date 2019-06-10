class UsersController < ApplicationController
	before_action :set_user, only: [:show, :update, :destroy]

	# GET /users
	def index
		@users = User.all
		json_response(@users)
	end

	  # POST /users
	def create
		if user_params_check
			begin
				response = RestClient::Request.execute(
				method: :get,
				url: 'http://tengsotusdatos.com/people/'+params[:nickname])
				# url: 'https://jsonplaceholder.typicode.com/todos/1')
				json = JSON.parse response
				add_params_to_users json
			rescue SocketError => e
			  # Handle your error here
			end

		end

		@user = User.create!(user_params)
		json_response(@user,:created)
	end

	# GET /user/:id
	def show
		json_response(@user)
	end

	# PUT /users/:id
	def update
		@user.update(user_params)
		head :no_content
	end

	# DELETE /users/:id
	def destroy
		@user.destroy
		head :no_content
	end
  
  	private
	
	def user_params_check
		required = [:first_name, :second_name, :last_name, :age, :email]
		if (!params.has_key?(:first_name) || !params.has_key?(:second_name) || !params.has_key?(:last_name) || !params.has_key?(:age)|| !params.has_key?(:email)) && params.has_key?(:nickname)
			return true
		else
			return false
		end
	end
	
	def add_params_to_users(json)
		if !params[:first_name].present?
			params.merge!(first_name: json['fname'])
		end
		if !params[:second_name].present?
			params.merge!(second_name: json['s_name'])
		end
		if !params[:last_name].present?
			params.merge!(last_name: json['l_name'])
		end
		if !params[:age].present?
			params.merge!(age: User.age(json['birthday']))
		end
		if !params[:email].present?
			params.merge!(email: json['email'])
		end
	end

	def user_params
		# whitelist params
		params.permit(:first_name, :second_name,:last_name, :nickname, :age, :email)
	end

	def set_user
		@user = User.find(params[:id])
	end
end
