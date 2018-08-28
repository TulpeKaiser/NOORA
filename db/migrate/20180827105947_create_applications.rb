class CreateApplications < ActiveRecord::Migration[5.2]
  def change
    create_table :applications do |t|
      t.string :name
      t.string :description
      t.string :logo
      t.string :webpage_url
      t.references :category, foreign_key: true

      t.timestamps
    end
  end
end
