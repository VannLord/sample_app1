module RelationshipsHelper
  def find_relationships user
    current_user.active_relationships.find_by(followed_id: user.id)
  end
end
