class Issue < ApplicationRecord
  include Filterable
  
  has_many :children, class_name: "Issue", foreign_key: "parent_id"
  belongs_to :parent, class_name: "Issue", optional: true
  has_many :instances
  has_many :builds, ->{ distinct }, through: :instances

  scope :distinct_issues, -> { group('issues.id') }
  scope :aggregate_hits, -> { distinct_issues.select('issues.*, count(issues.id) as hit_count').order("hit_count DESC") }
  scope :include_hit_count, -> { joins(:instances).distinct_issues.aggregate_hits }

  scope :build_product, -> (build_product) { joins(:builds).where(:builds=>{:product=>build_product}).aggregate_hits }
  scope :build_branch, -> (build_branch) { joins(:builds).where(:builds=>{:branch=>build_branch}).aggregate_hits }
  scope :build_name, -> (build_name) { joins(:builds).where(:builds=>{:name=>build_name}).aggregate_hits }
  scope :build_id, -> (build_id) { joins(:builds).where(:builds=>{:id=>build_id}).aggregate_hits }

  scope :signature, -> (signature) { joins(:builds).where(:signature=>signature).distinct_issues }
end
