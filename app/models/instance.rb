class Instance < ApplicationRecord
  belongs_to :issue, :counter_cache => true
end
