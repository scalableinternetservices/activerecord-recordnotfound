class User < ApplicationRecord
  has_many :chats_where_admin, class_name: "Chat", foreign_key: "admin_id", dependent: :destroy
  has_many :groups_where_admin, class_name: "Group", foreign_key: "admin_id", dependent: :destroy
  has_many :messages, dependent: :destroy
  has_many :posts, dependent: :destroy
  has_many :comments, dependent: :destroy

  has_secure_password

  validates :user_name, presence: true, uniqueness: { case_sensitive: false }
  validates :password, presence: true, on: :create
  validates :password_confirmation, presence: true, on: :create

  after_initialize :init_friend_arrays, if: :new_record?
  after_initialize :init_group_arrays, if: :new_record?

  def friends
    User.where(id: friend_ids)
  end

  def pending_friend_requests
    User.where(id: pending_friend_request_ids)
  end

  def send_friend_request(recipient)
    return false if friend_ids&.include?(recipient.id) || 
                   sent_friend_request_ids&.include?(recipient.id) ||
                   pending_friend_request_ids&.include?(recipient.id) ||
                   recipient.id == id

    User.transaction do
      self.sent_friend_request_ids ||= []
      recipient.pending_friend_request_ids ||= []

      self.sent_friend_request_ids = Array.wrap(sent_friend_request_ids) + [recipient.id]
      recipient.pending_friend_request_ids = Array.wrap(recipient.pending_friend_request_ids) + [id]
      
      save!
      recipient.save!
    end
    
    true
  rescue ActiveRecord::RecordInvalid
    false
  end

  def accept_friend_request(sender_id)
    return false unless pending_friend_request_ids&.include?(sender_id)
    
    sender = User.find(sender_id)
    
    User.transaction do
      self.friend_ids ||= []
      sender.friend_ids ||= []
      
      self.friend_ids = Array.wrap(friend_ids) + [sender_id]
      sender.friend_ids = Array.wrap(sender.friend_ids) + [id]
      
      self.pending_friend_request_ids = Array.wrap(pending_friend_request_ids) - [sender_id]
      sender.sent_friend_request_ids = Array.wrap(sender.sent_friend_request_ids) - [id]
      
      save!
      sender.save!
    end
    
    true
  rescue ActiveRecord::RecordInvalid
    false
  end

  def reject_friend_request(sender_id)
    return false unless pending_friend_request_ids&.include?(sender_id)
    
    sender = User.find(sender_id)
    
    User.transaction do
      self.pending_friend_request_ids = Array.wrap(pending_friend_request_ids) - [sender_id]
      sender.sent_friend_request_ids = Array.wrap(sender.sent_friend_request_ids) - [id]
      
      save!
      sender.save!
    end
    
    true
  rescue ActiveRecord::RecordInvalid
    false
  end

  def remove_friend(friend_id)
    return false unless friend_ids&.include?(friend_id)
    
    friend = User.find(friend_id)
    
    User.transaction do
      self.friend_ids = Array.wrap(friend_ids) - [friend_id]
      friend.friend_ids = Array.wrap(friend.friend_ids) - [id]
      
      save!
      friend.save!
    end
    
    true
  rescue ActiveRecord::RecordInvalid
    false
  end

  def join_group(group_id)
    self.group_ids << group_id unless group_ids.include?(group_id)
    save
  end

  def leave_group(group_id)
    self.group_ids.delete(group_id)
    save
  end

  def in_group?(group_id)
    return true if group_ids&.include?(group_id)
    false
  end

  private

  def init_friend_arrays
    self.friend_ids ||= []
    self.pending_friend_request_ids ||= []
    self.sent_friend_request_ids ||= []
  end

  def init_group_arrays
    self.group_ids ||= []
  end
end
