class ReportSerializer < ActiveModel::Serializer
  attributes :id, :lat, :lng, :user, :notes, :likes

  def user
    object.user
  end

  def likes
    object.likes
  end
end
