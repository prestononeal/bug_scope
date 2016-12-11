class Issue < ApplicationRecord
  include Filterable
  
  belongs_to :build
  belongs_to :issue, optional: true

  has_many :issues
  has_many :instances

  scope :build_product, -> (build_product) { joins(:build).where(:builds=>{:product=>build_product}) }
  scope :build_branch, -> (build_branch) { joins(:build).where(:builds=>{:branch=>build_branch}) }
  scope :build_name, -> (build_name) { joins(:build).where(:builds=>{:name=>build_name}) }
  scope :build_id, -> (build_id) { joins(:build).where(:builds=>{:id=>build_id}) }
end
