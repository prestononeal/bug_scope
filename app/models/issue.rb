class Issue < ApplicationRecord
  include Filterable
  
  belongs_to :issue, optional: true
  has_many :issues
  has_many :instances
  has_many :builds, ->{ distinct }, through: :instances

  scope :all_with_instances_count, -> { joins(:instances).group('issues.id').select('issues.*, count(issues.id) as instances_count').order("instances_count DESC") }
  scope :build_product, -> (build_product) { joins(:builds).where(:builds=>{:product=>build_product}).group('issues.id').select('issues.*, count(issues.id) as instances_count').order("instances_count DESC") }
  scope :build_branch, -> (build_branch) { joins(:builds).where(:builds=>{:branch=>build_branch}).group('issues.id').select('issues.*, count(issues.id) as instances_count').order("instances_count DESC") }
  scope :build_name, -> (build_name) { joins(:builds).where(:builds=>{:name=>build_name}).group('issues.id').select('issues.*, count(issues.id) as instances_count').order("instances_count DESC") }
  scope :build_id, -> (build_id) { joins(:builds).where(:builds=>{:id=>build_id}).group('issues.id').select('issues.*, count(issues.id) as instances_count').order("instances_count DESC") }
end
