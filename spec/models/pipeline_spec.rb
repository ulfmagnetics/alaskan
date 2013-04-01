require 'spec_helper'

describe Pipeline do
  describe '.build_from_board' do
    let(:board_id) { '12345678abcdef' }
    let(:board_name) { 'Engineering Pipeline' }
    let(:board_list_names) { [ "Recruiter Screen", "Programming Challenge", "Rejected", "Hired" ] }
    let(:board_lists) { board_list_names.map { |name| double('trello_list', :name => name) } }
    let(:board_card_names) { [ "First One", "Second One", "Third One" ] }
    let(:board_cards) { board_card_names.map { |name| double('trello_card', :name => name) } }
    let(:board) { double('board', :id => board_id, :name => board_name, :lists => board_lists, :cards => board_cards) }

    let(:candidate) { FactoryGirl.create(:candidate) }

    before do
      Candidate.stub(:build_from_card).and_return(candidate)
    end

    context "when board is not represented as a Pipeline" do
      it 'creates a new Pipeline for the board' do
        Pipeline.build_from_board(board).new_record?.should be_true
      end

      it 'initializes basic attributes correctly based on board data' do
        Pipeline.build_from_board(board).should satisfy do |pipeline|
          pipeline.board_id.should == board_id
          pipeline.name.should == board_name
        end
      end

      it 'creates states for each of the board lists' do
        pipeline_states = double('states')
        pipeline_states.should_receive(:build).with do |*args|
          params = args.pop
          board_list_names.should include(params[:name])
        end.exactly(board_list_names.size).times
        Pipeline.any_instance.stub(:states => pipeline_states, :contains_state? => false)
        Pipeline.build_from_board(board)
      end

      it "calls sync_candidate for each of the board's cards" do
        Pipeline.any_instance.should_receive(:sync_candidate).with do |*args|
          card = args.pop
          board_card_names.should include(card.name)
        end.exactly(board_card_names.size).times
        pipeline = Pipeline.build_from_board(board)
      end
    end

    context "when a board is already represented as a Pipeline" do
      before do
        FactoryGirl.create(:pipeline, board_id: board_id, name: 'Garbage Board')
      end

      it 'does not create a new board' do
        Pipeline.build_from_board(board).new_record?.should be_false
      end

      it 'updates an existing Pipeline with changes from the board' do
        Pipeline.build_from_board(board).name.should == board_name
      end

      it 'deletes states that are not represented as lists' # unimplemented functionality
    end
  end

  describe '#sync_candidate' do
    it 'creates a candidate if they are not yet in the pipeline'
    it 'updates a candidate if they are already in the pipeline'
  end
end