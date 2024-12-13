class AddUsersCountToGroups < ActiveRecord::Migration[7.1]
  def change
    add_column :groups, :memberships_count, :integer, default: 0, null: false

    Group.find_each do |group|
      group.update(memberships_count: group.memberships.count)
    end
  end
end
