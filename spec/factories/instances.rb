FactoryGirl.define do
  factory :instance_faker, class: 'Instance' do
  end

  factory :instance, :parent=>:instance_faker do
  end
end
