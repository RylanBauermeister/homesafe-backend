class Api::V1::CrimesController < ApplicationController

  def index
    crimes = Crime.getMostRecent
    render json: crimes
  end
end
