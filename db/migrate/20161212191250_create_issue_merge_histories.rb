class CreateIssueMergeHistories < ActiveRecord::Migration[5.0]
  def change
    create_table :issue_merge_histories do |t|
      t.references :old_issue, references: :issue
      t.references :new_issue, references: :issue
      t.references :instance, foreign_key: true

      t.timestamps
    end

    add_foreign_key :issue_merge_histories, :issues, column: :old_issue_id
    add_foreign_key :issue_merge_histories, :issues, column: :new_issue_id
  end
end
