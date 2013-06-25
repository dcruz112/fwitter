class CreateRetweets < ActiveRecord::Migration
  def change
    create_table :retweets do |t|
      t.text :content
      t.string :user_id
      t.string :poster_id

      t.timestamps
    end
  end
end
