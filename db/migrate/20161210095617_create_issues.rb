class CreateIssues < ActiveRecord::Migration[5.0]
  def change
    create_table :issues do |t|
      t.string :issue_type
      t.text :signature
      t.string :ticket

      t.timestamps
    end
  end
end
