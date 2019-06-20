class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  def self.coordsFromAddress(address)
    data = HTTParty.get("https://maps.googleapis.com/maps/api/geocode/json?address=#{self.urlify(address)}&key=#{ENV["google_api_key"]}")
    data["results"] && data["status"] != "ZERO_RESULTS" ? data["results"][0]["geometry"]["location"] : {}
  end

  def self.urlify(address)
    address.gsub(" ", "+")+"+seattle,+WA"
  end
end
