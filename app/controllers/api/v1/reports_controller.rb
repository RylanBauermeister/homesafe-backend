class Api::V1::ReportsController < ApplicationController

  skip_before_action :valid_signature?, only: [:index]

  def index
    render json: Report.all, status: :ok
  end


  def create
    @user = User.find(params[:user_id])
    @report = Report.reportFromData(report_params, @user)
    if @report.save
      render json: @report, status: :ok
    else
      render json: {error: "Unable to save report"}, status: :not_acceptable
    end
  end

  def destroy
    @report = Report.find(params[:id])
    @report.delete
    render json: Report.all, status: :accepted
  end

  def like
    @report = Report.find(params[:id])
    @like = Like.new({report: @report, user_id: params[:user_id]})
    if @like.save
      render json: {likes: @report.likes}, status: :ok
    else
      render json: {error: "unable to like"}, status: :not_acceptable
    end
  end

  def unlike
    @report = Report.find(params[:id])
    @user = User.find(params[:user_id])
    @like = Like.find_by({user: @user, report: @report})
    if @like.delete
      render json: {likes: @report.likes}, status: :ok
    else
      render json: {error: "unable to dislike."}, status: :not_acceptable
    end

  end


  private
  def report_params
    params.require(:report).permit(:address, :notes, :username)
  end
end
