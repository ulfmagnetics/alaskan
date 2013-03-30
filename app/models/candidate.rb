class Candidate < ActiveRecord::Base
  attr_accessible :current_state, :entry_date, :exit_date, :exit_state, :name, :role

  def self.valid_states
    @@valid_states ||= [
      "Bounced", "Recruiter Screen", "Tech Screen",
      "Programming Challenge", "Review Programming Challenge",
      "Pairing Test", "Onsite Interview", "Rejected", "Hired"
    ]
  end

  validates :name, :entry_date, presence: true
  validates :current_state, inclusion: valid_states

  def self.build_from_card(card)

  end
end
