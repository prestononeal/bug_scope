class CreateBuilds < ActiveRecord::Migration[5.0]
  def change
    create_table :builds do |t|
      t.string :name
      t.string :branch
      t.string :product

      t.timestamps
    end
  end
end
