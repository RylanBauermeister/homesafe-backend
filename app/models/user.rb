class User < ApplicationRecord
  has_many :reports
  has_many :avoids
  has_many :likes
  has_many :liked_reports, through: :likes, source: "report"
end
