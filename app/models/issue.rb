class Issue < ApplicationRecord
  include Filterable

  after_create :set_default_parent
  
  has_many :children, class_name: "Issue", foreign_key: "parent_id"
  belongs_to :parent, class_name: "Issue", optional: true
  has_many :instances
  has_many :child_instances, through: :children, source: :instances
  has_many :builds, ->{ distinct }, through: :instances

  scope :distinct_issues, -> { group('issues.id') }
  scope :include_hit_count, -> { joins(:instances).group('issues.id').select('issues.*, count(issues.id) as instances_count').order("id") }
  scope :include_hit_count_children, -> { joins(:child_instances).group('issues.id').select('issues.*, count(issues.id) as instances_count').order("id") }
  scope :build_product, -> (build_product) { joins(:builds).distinct_issues.where(:builds=>{:product=>build_product}) }
  scope :build_branch, -> (build_branch) { joins(:builds).distinct_issues.where(:builds=>{:branch=>build_branch}) }
  scope :build_name, -> (build_name) { joins(:builds).distinct_issues.where(:builds=>{:name=>build_name}) }
  scope :build_id, -> (build_id) { joins(:builds).distinct_issues.where(:builds=>{:id=>build_id}) }
  scope :signature, -> (signature) { joins(:builds).distinct_issues.where(:signature=>signature) }

  private
    def set_default_parent
      self.update_columns(parent_id: id) if parent.nil?
    end
end
