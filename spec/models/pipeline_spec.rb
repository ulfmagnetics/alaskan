require 'spec_helper'

describe Pipeline do
  describe '.build_from_board' do
    context "when board is already represented as a Pipeline" do
      it 'updates an existing Pipeline with changes from the board'
    end

    context "when board is not represented as a Pipeline" do
      it 'creates a new Pipeline for the board'
    end

    it "creates a Candidate for each of the board's cards"
  end
end
