class Api::V1::UsersController < ApplicationController

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

  def update
    @user = User.find(params[:id])
    if @user.update(user_parameters)
      render json: @user, status: :ok
    else
      render json: {error: "Bad parameters"}, status: :unacceptable
    end
  end


  private
  def user_parameters
    params.require(:user).permit(:username, :foreign_id, crime_weights:[:crimesAgainstPersons, :crisisAndInjury, :drugsAndVice, :miscCrimes, :propertyCrime, :trafficCrime])
  end



end
