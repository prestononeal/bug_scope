# Taken from http://www.justinweiss.com/articles/search-and-filter-rails-models-without-bloating-your-controller/
# Pretty cool.
module Filterable
  extend ActiveSupport::Concern

  module ClassMethods
    def filter(filtering_params)
      results = self.where(nil)
      filtering_params.each do |key, value|
        results = results.public_send(key, value) if value.present?
      end
      results
    end
  end
end
