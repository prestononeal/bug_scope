class CreateInstances < ActiveRecord::Migration[5.0]
  def change
    create_table :instances do |t|
      t.references :issue, foreign_key: true

      t.timestamps
    end
  end
end
