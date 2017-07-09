class CreateUrls < ActiveRecord::Migration[5.0]
  def change
    create_table :urls do |t|
      t.string :url, null: false
      t.boolean :status, null: false
      t.string :html
      t.timestamps
    end
  end
end
