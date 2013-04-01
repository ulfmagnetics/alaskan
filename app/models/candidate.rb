class Candidate < ActiveRecord::Base
  attr_accessible :card_id, :current_state, :entry_date, :exit_date, :exit_state, :name, :role

  belongs_to :pipeline

  validates :card_id, :name, :entry_date, presence: true

  def self.build_from_card(card, final_states)
    Candidate.new(card_to_params(card)).tap do |candidate|
      find_exit_actions(card, final_states).tap do |exit_actions|
        if !exit_actions.empty?
          initial_exit_action = exit_actions.last  # only consider the first time the card entered a final state
          candidate.update_attributes(exit_state: initial_exit_action.data['listBefore']['name'], exit_date: initial_exit_action.date)
        end
      end
    end
  rescue => ex
    Rails.logger.error "Caught an exception while building card #{card.name}: #{ex}"
    nil
  end

  def self.card_to_params(card)
    matches = /(.*?)\s*[\-:,\s]\s*(.*?)\s*[\-:,]\s*(.*?)$/.match(card.name)
    entry_date = Date.strptime([matches[1], card.actions.last.date.year].join("/"), "%m/%d/%Y")
    {
      card_id: card.id,
      entry_date: entry_date,
      name: matches[2],
      role: matches[3],
      current_state: card.list.name
    }
  end

  def update_from_card(card)
    update_attributes(Candidate.card_to_params(card))
  end

  private

  def self.find_exit_actions(card, final_states)
    card.actions(filter: 'updateCard:idList').select do |action|
      action.data['listAfter'] && final_states.include?(action.data['listAfter']['name'])
    end
  end
end
