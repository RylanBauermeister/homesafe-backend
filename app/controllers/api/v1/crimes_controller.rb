class Api::V1::CrimesController < ApplicationController
  skip_before_action :valid_signature?
  
  def index
    crimes = Crime.getMostRecent
    render json: crimes
  end
end
