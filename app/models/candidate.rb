class Candidate < ActiveRecord::Base
  attr_accessible :current_state, :entry_date, :exit_date, :exit_state, :name, :role

  belongs_to :pipeline

  validates :name, :entry_date, presence: true

  # FIXME this should be a call to the card's pipeline
  def self.final_states
    %w{ Rejected Hired }
  end

  def self.build_from_card(card)
    matches = /(.*?)\s*[\-:,]\s*(.*?)\s*[\-:,]\s*(.*?)$/.match(card.name)
    entry_date = Date.strptime([matches[1], card.actions.last.date.year].join("/"), "%m/%d/%Y")
    params = {
      entry_date: entry_date,
      name: matches[2],
      role: matches[3],
      current_state: card.list.name
    }

    Candidate.new(params).tap do |candidate|
      find_exit_actions_for_card(card).tap do |exit_actions|
        if !exit_actions.empty?
          initial_exit_action = exit_actions.last  # only consider the first time the card entered a final state
          candidate.update_attributes(exit_state: initial_exit_action.data['listBefore']['name'], exit_date: initial_exit_action.date)
        end
      end
    end
  end

  def self.find_exit_actions_for_card(card)
    card.actions(filter: 'updateCard:idList').select do |action|
      action.data['listAfter'] && final_states.include?(action.data['listAfter']['name'])
    end
  end
end
