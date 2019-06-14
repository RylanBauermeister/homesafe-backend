class UserSerializer < ActiveModel::Serializer
  attributes :id, :username, :avoids, :crime_weights, :foreign_id

  def avoids
    object.avoids
  end
end
