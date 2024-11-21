class Post < ApplicationRecord
  belongs_to :user
  belongs_to :group
  validates :post_name, presence: true
  has_many :comments, dependent: :destroy
end
