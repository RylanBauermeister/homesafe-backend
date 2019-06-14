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


  private
  def report_params
    params.require(:report).permit(:address, :notes, :username)
  end
end
