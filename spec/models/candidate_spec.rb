require 'spec_helper'

describe Candidate do
  let(:sometime) { "2013-03-21 19:00:00 PST".to_time }

  describe '.build_from_card' do
    let(:card_name) { "03/15 - Mina Doroudi - Software Engineer" }
    let(:card_creation_date) { sometime - 2.weeks }
    let(:card_creation_action) { double('card_creation_action', :date => card_creation_date, :data => {}) }
    let(:card_actions) { [ card_creation_action ] }
    let(:card_list) { double('card_list', :name => "Programming Challenge") }
    let(:card) { double('trello_card', :id => '123456ab', :name => card_name, :list => card_list, :actions => card_actions) }
    let(:final_states) { %w{ Rejected Hired } }

    before do
      Timecop.travel(sometime)
    end

    it 'initializes basic attributes correctly based on card data' do
      Candidate.build_from_card(card, final_states).should satisfy do |candidate|
        candidate.name.should == "Mina Doroudi"
        candidate.role.should == "Software Engineer"
        candidate.entry_date.year.should == card_creation_date.year
        candidate.current_state.should == card_list.name
        candidate.exit_state.should be_nil
        candidate.exit_date.should be_nil
        candidate.valid?.should be_true
      end
    end

    context 'when card name has a slightly different format' do
      let(:card_name) { "3/15 Mina Doroudi - Software Engineer" }
      it 'parses attributes correctly' do
        Candidate.build_from_card(card, final_states).should satisfy do |candidate|
          candidate.name.should == "Mina Doroudi"
          candidate.role.should == "Software Engineer"
        end
      end
    end

    context 'when role is missing' do
      let(:card_name) { "3/15 - Mina Doroudi" }
      it 'parses attributes correctly' do
        Candidate.build_from_card(card, final_states).should satisfy do |candidate|
          candidate.name.should == "Mina Doroudi"
          candidate.role.should be_blank
        end
      end
    end

    context 'when card was created in a different year' do
      let(:card_creation_date) { sometime - 1.year }

      it 'generates a valid Candidate who entered the pipeline in the year the card was created' do
        Candidate.build_from_card(card, final_states).entry_date.year.should == card_creation_date.year
      end
    end

    context "when the card's actions contain a transition to the final state" do
      let(:rejection_date) { sometime - 3.days}
      let(:exit_state) { 'Programming Challenge' }
      let(:final_state) { final_states.first }
      let(:rejection_action_data) { {'listBefore' => { 'name' => exit_state }, 'listAfter' => { 'name' => final_state } } }
      let(:rejection_action) { double('rejection_action', :type => 'updateCard', :date => rejection_date, :data => rejection_action_data) }
      let(:card_actions) { [ rejection_action, card_creation_action ] }
      let(:card_list) { double('card_list', :name => final_state) }

      it 'sets the exit state and exit date correctly' do
        Candidate.build_from_card(card, final_states).should satisfy do |candidate|
          candidate.exit_state.should == exit_state
          candidate.exit_date.should == rejection_date
        end
      end
    end
  end

  describe '#starting' do
    it 'returns only Candidates who entered the pipeline after the given date'
  end

  describe '#ending' do
    it 'returns only Candidates who entered the pipeline before the given date'
  end
end
