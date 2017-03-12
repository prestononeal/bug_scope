class AddParentRefToIssues < ActiveRecord::Migration[5.0]
  def change
    add_reference :issues, :parent, index: true
    add_foreign_key :issues, :issues, column: :parent_id
  end
end
