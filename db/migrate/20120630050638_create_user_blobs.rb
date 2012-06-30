class CreateUserBlobs < ActiveRecord::Migration
  def change
    create_table :user_blobs do |t|
      t.text :content
      t.integer :user_id

      t.timestamps
    end

    add_index :user_blobs, :user_id
  end
end
