class RemoveIssueFromIssue < ActiveRecord::Migration[5.0]
  def change
    remove_reference :issues, :issue, foreign_key: true
  end
end
