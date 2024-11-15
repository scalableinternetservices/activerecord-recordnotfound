class Group < ApplicationRecord
  belongs_to :admin, class_name: "User", foreign_key: "admin_id"
  has_many :posts, dependent: :destroy

  def count_users_in_group(group_id)
    User.where('? = ANY (group_ids)', group_id).count
  end

end
