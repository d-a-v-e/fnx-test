class UsersController < ApplicationController

  before 
  
  def index
  end

  def check_mobile
    @user = User.find_or_create_with_valid_mobile(mobile: user_params[:mobile])
    if @user.valid?
      @user.check(user_params[:code])
      render json: { message: @user.status_message, message_code: @user.status_message_code }
    else
      render json: { message: @user.errors.as_json }, status: 400
    end
  end

  private

  def user_params
    params.permit(:mobile, :code)
  end

end
