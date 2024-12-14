class Group < ApplicationRecord
  belongs_to :admin, class_name: "User", foreign_key: "admin_id"
  has_many :posts, dependent: :destroy

  # optimization via join table
  has_many :memberships, dependent: :destroy
  has_many :users, through: :memberships

  def count_users_in_group(group_id)
    Group.find(group_id)&.memberships_count
  end

end
