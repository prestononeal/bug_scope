class IssueMergeHistory < ApplicationRecord
  belongs_to :issue
  belongs_to :issue
  belongs_to :instance
end
