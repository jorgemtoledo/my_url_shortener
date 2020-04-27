class CreateLinks < ActiveRecord::Migration[6.0]
  def change
    create_table :links do |t|
      t.text :url
      t.string :slug
      t.string :sanitize_url

      t.timestamps
    end
  end
end
