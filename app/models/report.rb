class Report < ApplicationRecord
  belongs_to :user
  has_many :likes
  has_many :liking_users, through: :likes, source: "user"

  def self.reportFromData(report, user)
    coords = coordsFromAddress(report["address"])
    return Report.new({lat: coords["lat"], lng: coords["lng"], notes: report["notes"], user: user}) if coords
  end

  def self.clear
    Report.all.delete_all
  end

end
