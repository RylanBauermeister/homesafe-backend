class Api::V1::UsersController < ApplicationController
  before_action :valid_signature?


  def my_profile
    @user = User.find_or_initialize_by(user_parameters) do |user|
      user.crime_weights = {}
    end

    if @user.save
      render json: @user
    else
      render json: @user.error
    end
  end

  private
  def valid_signature?
    @oauth = Koala::Facebook::OAuth.new(Rails.application.credentials.dig(:facebook)[:app_id], Rails.application.credentials.dig(:facebook)[:app_secret])
    begin
      @oauth.parse_signed_request(params[:signature])
    rescue Koala::Facebook::OAuthSignatureError
      render json: {"error": "invalid signature"}
    rescue JSON::ParserError
      render json: {"error": "invalid json in signature"}
    end
  end

  def user_parameters
    params.require(:user).permit(:username, :foreign_id)
  end



end
