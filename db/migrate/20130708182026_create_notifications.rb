class CreateNotifications < ActiveRecord::Migration
  def change
    create_table :notifications do |t|
      t.string :content
      t.string :image_url
      t.references :user, index: true

      t.timestamps
    end
  end
end
