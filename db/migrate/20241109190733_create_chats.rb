class CreateChats < ActiveRecord::Migration[7.1]
  def change
    create_table :chats do |t|
      t.string :chat_name
      t.integer :admin_id

      t.timestamps
    end
  end
end
