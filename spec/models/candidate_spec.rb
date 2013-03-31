require 'spec_helper'

describe Candidate do
  describe '.build_from_card' do
    let(:sometime) { "2013-03-21 19:00:00 PST".to_time }
    let(:card) do
      double('trello_card', :name => "03/15 - Mina Doroudi - Software Engineer").tap do |card|
        card.stub_chain(:actions, :last).and_return(card_creation_action)
      end
    end

    before do
      Timecop.travel(sometime)
    end

    context "when card was created in a different year" do
      let(:sometime_last_year) { sometime - 1.year }
      let(:card_creation_action) { double('card_creation_action', :date => sometime_last_year) }

      it 'generates a valid Candidate who entered the pipeline in the year the card was created' do
        Candidate.build_from_card(card).should satisfy do |cand|
          cand.name.should == "Mina Doroudi"
          cand.role.should == "Software Engineer"
          cand.entry_date.should == Date.strptime("#{sometime_last_year.year}-03-15")
          cand.valid?.should be_true
        end
      end
    end
  end

  it 'updates itself if the Trello board has changed'

  describe '#starting' do
    it 'returns only Candidates who entered the pipeline after the given date'
  end

  describe '#ending' do
    it 'returns only Candidates who entered the pipeline before the given date'
  end
end
