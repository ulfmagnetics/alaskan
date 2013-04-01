FactoryGirl.define do
  sequence(:name) { |n| "Candidate #{n}" }

  factory :pipeline do
  end

  factory :state do
  end

  factory :candidate do
    name { generate :name }
    entry_date Time.now.to_date
  end

  # TODO add any required factories here.
end