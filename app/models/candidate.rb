class Candidate < ActiveRecord::Base
  attr_accessible :current_state, :entry_date, :exit_date, :exit_state, :name, :role

  validates :name, :entry_date, presence: true
  validates :current_state, inclusion: Candidate.valid_states

  TRELLO_API_KEY = "45de82c39b680f558d905b0ce888a160"

  def self.valid_states
    @@valid_states ||= [
      "Bounced", "Recruiter Screen", "Tech Screen",
      "Programming Challenge", "Review Programming Challenge",
      "Pairing Test", "Onsite Interview", "Rejected", "Hired"
    ]
  end

  def self.build_from_api_response

  end
end
