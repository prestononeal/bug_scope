FactoryGirl.define do
  factory :build_faker, class: 'Build' do
    name { Faker::Number.between(1, 10) }
    branch { Faker::Team.state }
    product { Faker::Hacker.noun }
  end

  factory :build, :parent=>:build_faker do
  end
end
