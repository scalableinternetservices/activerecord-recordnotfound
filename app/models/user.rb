class User < ApplicationRecord
  has_many :chats_where_admin, class_name: "Chat", foreign_key: "admin_id", dependent: :destroy
  has_many :groups_where_admin, class_name: "Group", foreign_key: "admin_id", dependent: :destroy
  has_many :messages, dependent: :destroy
  has_many :posts, dependent: :destroy
  has_many :comments, dependent: :destroy

  has_secure_password

  validates :user_name, presence: true, uniqueness: { case_sensitive: false }
  validates :password, presence: true
  validates :password_confirmation, presence: true
end
