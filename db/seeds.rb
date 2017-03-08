# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).

30.times { FactoryGirl.create(:build) }

200.times { FactoryGirl.create(:issue) }

500.times {
  # Go through and create random associations of builds and issues through instances
  iss = Issue.all.sample
  bld = Build.all.sample
  FactoryGirl.create(:instance, :issue_id => iss.id, :build_id => bld.id)
}

