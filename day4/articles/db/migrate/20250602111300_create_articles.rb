class CreateArticles < ActiveRecord::Migration[8.0]
  def change
    create_table :articles do |t|
      t.string :title
      t.text :content
      t.references :user, null: false, foreign_key: true
      t.string :image
      t.integer :reports_count, default: 0
      t.boolean :archived, default: false

      t.timestamps
    end
  end
end
