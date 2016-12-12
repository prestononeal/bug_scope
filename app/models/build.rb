class Build < ApplicationRecord
  has_many :instances

  has_many :issues, through: :instances

  default_scope { order(id: :desc) }
end
