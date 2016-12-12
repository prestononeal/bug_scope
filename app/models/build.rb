class Build < ApplicationRecord
  has_many :issues

  default_scope { order(id: :desc) }
end
