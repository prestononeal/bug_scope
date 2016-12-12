class Instance < ApplicationRecord
  belongs_to :issue, :counter_cache => true
  belongs_to :build

  has_many :issue_merge_histories
end
