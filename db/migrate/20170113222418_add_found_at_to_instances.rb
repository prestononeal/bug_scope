class AddFoundAtToInstances < ActiveRecord::Migration[5.0]
  def change
    add_column :instances, :found_at, :datetime
  end
end
