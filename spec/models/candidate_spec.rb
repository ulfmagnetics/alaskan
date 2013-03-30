require 'spec_helper'

describe Candidate do
  describe '.build_from_card' do
    let(:card) { Factory(:trello_card, name: "11/15 - Mina Doroudi - Software Engineer") }

    it 'generates a valid Candidate given a Card instance' do
      expect { Candidate.build_from_card(card) }.to satisfy do |c|
        c.should be_kind_of Candidate
        c.name should == "Mina Doroudi"
        c.role should == "Software Engineer"
        c.entry_date should == Date.strptime("2013-11-15")
      end
    end
  end
end
