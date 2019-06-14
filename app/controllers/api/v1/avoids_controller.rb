class Api::V1::AvoidsController < ApplicationController
  def index
    render json: Avoid.all, status: :ok
  end


  def create
    @user = User.find(params[:user_id])
    @avoid = Avoid.avoidFromData(avoid_params, @user)
    if @avoid.save
      render json: @avoid, status: :ok
    else
      render json: {error: "Unable to save avoid"}, status: :not_acceptable
    end
  end

  def destroy
    @avoid = Avoid.find(params[:id])
    @avoid.delete
    render json: Avoid.all, status: :accepted
  end


  private
  def avoid_params
    params.require(:avoid).permit(:address, :notes, :username)
  end
end
