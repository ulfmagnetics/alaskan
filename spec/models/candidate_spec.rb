require 'spec_helper'

describe Candidate do
  let(:sometime) { "2013-03-21 19:00:00 PST".to_time }

  describe '.build_from_card' do
    let(:pipeline) { double('pipeline', :exit_state => 'Rejected') }

    let(:card_name) { "03/15 - Mina Doroudi - Software Engineer" }
    let(:card_creation_date) { sometime - 2.weeks }
    let(:card_creation_action) { double('card_creation_action', :date => card_creation_date) }
    let(:card_actions) { [ card_creation_action ] }
    let(:card_list) { double('card_list', :name => "Programming Challenge") }
    let(:card) { double('trello_card', :name => card_name, :list => card_list, :actions => card_actions) }

    let(:the_candidate) do
      Candidate.build_from_card(card).tap do |candidate|
        candidate.stub(:pipeline => pipeline)
      end
    end

    before do
      Timecop.travel(sometime)
    end

    it 'initializes basic attributes correctly based on card data' do
      the_candidate.should satisfy do |candidate|
        candidate.name.should == "Mina Doroudi"
        candidate.role.should == "Software Engineer"
        candidate.entry_date.year.should == card_creation_date.year
        candidate.current_state.should == card_list.name
        candidate.exit_state.should be_nil
        candidate.exit_date.should be_nil
        candidate.valid?.should be_true
      end
    end

    context 'when card was created in a different year' do
      let(:card_creation_date) { sometime - 1.year }

      it 'generates a valid Candidate who entered the pipeline in the year the card was created' do
        the_candidate.entry_date.year.should == card_creation_date.year
      end
    end

    context "when the card's actions contain a transition to the exit state" do
      before do

      end

      it 'sets the exit state and exit date correctly'
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
