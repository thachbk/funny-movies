class CreateVideos < ActiveRecord::Migration[7.1]
  def change
    create_table :videos do |t|
      t.references :user, foreign_key: true, index: true, null: false
      t.string :title, null: false
      t.text :description
      t.string :url, null: false

      t.timestamps
    end
  end
end
