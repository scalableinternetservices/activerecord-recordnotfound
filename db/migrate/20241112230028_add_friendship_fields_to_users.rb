class AddFriendshipFieldsToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :friend_ids, :integer, array: true, default: []
    add_column :users, :pending_friend_request_ids, :integer, array: true, default: []
    add_column :users, :sent_friend_request_ids, :integer, array: true, default: []
  end
end
