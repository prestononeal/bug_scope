namespace :issues do
  desc "Rake tasks related to the Issues model"
  task set_default_parent: :environment do
    Issue.where(:parent_id=>nil).each { |iss| iss.update_columns(parent_id: iss.id) }
  end
end
