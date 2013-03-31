class Candidate < ActiveRecord::Base
  attr_accessible :current_state, :entry_date, :exit_date, :exit_state, :name, :role

  validates :name, :entry_date, presence: true

  def self.build_from_card(card)
    matches = /(.*?)\s*[\-:,]\s*(.*?)\s*[\-:,]\s*(.*?)$/.match(card.name)
    entry_date = Date.strptime([matches[1], card.actions.last.date.year].join("/"), "%m/%d/%Y")
    Candidate.new(entry_date: entry_date, name: matches[2], role: matches[3])
  end
end
