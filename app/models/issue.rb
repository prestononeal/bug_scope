class Issue < ApplicationRecord
  include Filterable
  
  has_many :children, class_name: "Issue", foreign_key: "parent_id"
  belongs_to :parent, class_name: "Issue", optional: true
  has_many :instances
  has_many :builds, ->{ distinct }, through: :instances

  scope :distinct_issues, -> { group('issues.id') }
  scope :include_instances_count, -> { joins(:instances).group('issues.id').select('issues.*, count(issues.id) as instances_count').order("instances_count DESC") }
  scope :build_product, -> (build_product) { joins(:builds).distinct_issues.where(:builds=>{:product=>build_product}) }
  scope :build_branch, -> (build_branch) { joins(:builds).distinct_issues.group('issues.id').where(:builds=>{:branch=>build_branch}) }
  scope :build_name, -> (build_name) { joins(:builds).distinct_issues.group('issues.id').where(:builds=>{:name=>build_name}) }
  scope :build_id, -> (build_id) { joins(:builds).distinct_issues.group('issues.id').where(:builds=>{:id=>build_id}) }
  scope :signature, -> (signature) { joins(:builds).distinct_issues.group('issues.id').where(:signature=>signature) }
end
