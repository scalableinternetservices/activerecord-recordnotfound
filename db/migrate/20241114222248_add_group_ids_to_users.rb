class AddGroupIdsToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :group_ids, :integer, array: true, default: []
  end
end
