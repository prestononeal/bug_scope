class Instance < ApplicationRecord
  belongs_to :issue
  belongs_to :build

  before_create :create_default_values

  def create_default_values
    unless self.found_at
      # Did we not provide a found_at time? Set it to the time this entry was created
      self.found_at ||= self.created_at
    end
  end
end
