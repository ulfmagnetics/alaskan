class Candidate < ActiveRecord::Base
  attr_accessible :current_state, :entry_date, :exit_date, :exit_state, :name, :role

  validates :name, :entry_date, presence: true
  validates :current_state, inclusion: Candidate.valid_states

  def self.valid_states
    @@valid_states ||= [
      "Bounced", "Recruiter Screen", "Tech Screen",
      "Programming Challenge", "Review Programming Challenge",
      "Pairing Test", "Onsite Interview", "Rejected", "Hired"
    ]
  end

  def self.pipeline_board
    @@board ||= Trello::Board.find(Trello.pipeline_board_id)
  end

  def self.build_from_api_response

  end
end
