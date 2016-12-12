class Instance < ApplicationRecord
  has_paper_trail
  belongs_to :issue, :counter_cache => true
  belongs_to :build
end
