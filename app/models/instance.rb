class Instance < ApplicationRecord
  has_paper_trail
  belongs_to :issue
  belongs_to :build
end
