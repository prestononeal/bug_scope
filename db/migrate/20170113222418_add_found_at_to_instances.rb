class AddFoundAtToInstances < ActiveRecord::Migration[5.0]
  def change
    add_column :instances, :found_at, :datetime
    reversible do |direction|
      direction.up do
        # If the migration is being applied, set the found_at equal to created_at as a default
        # Future writes will rely on the model to set the default value
        Instance.find_each do |instance|
          instance.found_at ||= instance.created_at
          instance.save!
        end
      end
    end
  end
end
