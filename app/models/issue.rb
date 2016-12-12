class Issue < ApplicationRecord
  include Filterable
  
  belongs_to :issue, optional: true
  has_many :issues
  has_many :instances
  has_many :builds, through: :instances

  default_scope { order(instances_count: :desc) }

  scope :build_product, -> (build_product) { joins(:builds).where(:builds=>{:product=>build_product}).distinct }
  scope :build_branch, -> (build_branch) { joins(:builds).where(:builds=>{:branch=>build_branch}).distinct }
  scope :build_name, -> (build_name) { joins(:builds).where(:builds=>{:name=>build_name}).distinct }
  scope :build_id, -> (build_id) { joins(:builds).where(:builds=>{:id=>build_id}).distinct }
end
