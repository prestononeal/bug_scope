class AddCounterCacheToIssue < ActiveRecord::Migration[5.0]
  def change
    add_column :issues, :instances_count, :integer, default: :id
  end
end
