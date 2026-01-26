class Api::V1::UsersController < ActionController::API
      before_action :set_user, only: [:update, :destroy]
  # Signup
      def create
        user = User.new(user_params)
        if user.save
          session[:user_id] = user.id
          render json: { message: "Signup successful", user: user }, status: :created
        else
          render json: { error: user.errors.full_messages }, status: :unprocessable_entity
        end
      end
# users_controller.rb - Add profile method
def profile
  user = User.find_by(id: session[:user_id])
  if user
    render json: { user: user }, status: :ok
  else
    render json: { error: "Not authenticated" }, status: :unauthorized
  end
end
# users_controller.rb - Update login method
def login
  user = User.find_by(email: params[:user][:email])

  if user&.authenticate(params[:user][:password])
    session[:user_id] = user.id
    render json: { 
      message: "Login successful", 
      user: {
        id: user.id,
        name: user.name,
        email: user.email,
        role: user.role # Add role to response
      }
    }, status: :ok
  else
    render json: { error: "Invalid credentials" }, status: :unauthorized
  end
end
  def update
    if @user.update(user_params)
      render json: { 
        message: "User updated successfully", 
        user: @user 
      }, status: :ok
    else
      render json: { error: @user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    # Don't allow admin to delete themselves
    if @user.id == session[:user_id]
      render json: { error: "Cannot delete your own account" }, status: :unprocessable_entity
      return
    end
    if @user.destroy
      render json: { message: "User deleted successfully" }, status: :ok
    else
      render json: { error: @user.errors.full_messages }, status: :unprocessable_entity
    end
  end
# Also update create method
def create
  user = User.new(user_params)
  if user.save
    session[:user_id] = user.id
    render json: { 
      message: "Signup successful", 
      user: {
        id: user.id,
        name: user.name,
        email: user.email,
        role: user.role # Add role
      }
    }, status: :created
  else
    render json: { error: user.errors.full_messages }, status: :unprocessable_entity
  end
end
# users_controller.rb - Add logout method
def logout
  session[:user_id] = nil
  render json: { message: "Logged out successfully" }, status: :ok
end
  def index
    users = User.all
    render json: users
  end
      private

      def user_params
        params.require(:user).permit(:name, :email, :password, :role)
      end
       def set_user
         @user = User.find(params[:id])
       end 
end
