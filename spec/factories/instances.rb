FactoryGirl.define do
  factory :instance_faker, class: 'Instance' do
    found_at { Faker::Time.between(60.days.ago, Date.today, :all) }
  end

  factory :instance, :parent=>:instance_faker do
  end
end
