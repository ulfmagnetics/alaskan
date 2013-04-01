FactoryGirl.define do
  sequence(:name) { |n| "Candidate #{n}" }

  factory :pipeline do
  end

  factory :state do
  end

  factory :candidate do
    card_id     { "%08x" % (rand * 0xffffffff) }
    name        { generate :name }
    entry_date  Time.now.to_date
  end

  # TODO add any required factories here.
end