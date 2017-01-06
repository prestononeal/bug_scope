class RemoveInstancesCountFromIssues < ActiveRecord::Migration[5.0]
  def change
    remove_column :issues, :instances_count, :integer
  end
end
