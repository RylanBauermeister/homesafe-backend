class Avoid < ApplicationRecord
  belongs_to :user

  def self.avoidFromData(report, user)
    coords = coordsFromAddress(report["address"])
    return Avoid.new({lat: coords["lat"], lng: coords["lng"], notes: report["notes"], user: user}) if coords
  end

  def self.clear
    Avoid.all.delete_all
  end
end
