class Issue < ApplicationRecord
  belongs_to :build
  belongs_to :issue
end
