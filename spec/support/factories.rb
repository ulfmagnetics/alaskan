FactoryGirl.define do
  factory :trello_card, class: Trello::Card do
    closed false
  end
end