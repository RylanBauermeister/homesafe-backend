class Like < ApplicationRecord
  belongs_to :report
  belongs_to :user
end
