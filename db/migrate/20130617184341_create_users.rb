class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :first_name
      t.string :last_name
      t.string :netid
      t.string :handle
      t.text :biography
      t.string :current_location

      t.timestamps
    end
  end
end
