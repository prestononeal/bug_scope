FactoryBot.define do
  factory :issue_faker, class: 'Issue' do
    issue_type { ['watchdog', 'fatalassert', 'hardfault'].sample }
    signature { Faker::Internet.domain_name }
    ticket { ['JIRA-' + Faker::Number.between(1, 5).to_s, nil, nil].sample }
    state { ['open', 'closed', nil, nil].sample }
    note { Faker::Hacker.say_something_smart }
  end

  factory :issue, :parent=>:issue_faker do
  end
end
