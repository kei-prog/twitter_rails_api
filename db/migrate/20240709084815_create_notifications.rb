class CreateNotifications < ActiveRecord::Migration[7.0]
  def change
    create_table :notifications do |t|
      t.references :user, null: false, foreign_key: true
      t.references :send_user, null: false, foreign_key: { to_table: :users }
      t.integer :notification_type
      t.references :target, polymorphic: true, null: false

      t.timestamps
    end
  end
end
