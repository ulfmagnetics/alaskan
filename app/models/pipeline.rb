class Pipeline < ActiveRecord::Base
  attr_accessible :board_id, :last_synced_at, :name

  has_many :candidates
  has_many :states

  def self.states_that_look_final
    @@states_that_look_final ||= %w{ Rejected Hired }
  end

  def self.build_from_board(board)
    Pipeline.where(board_id: board.id).first_or_initialize.tap do |pipeline|
      pipeline.name = board.name
      pipeline.last_synced_at = Time.now

      board.lists.each do |list|
        unless pipeline.contains_state?(list.name)
          pipeline.states.build(name: list.name, final: states_that_look_final.include?(list.name))
        end
      end

      board.cards.each do |card|
        pipeline.sync_candidate(card)
      end
    end
  end

  def sync_candidate(card)
    existing_candidate = candidates.find_last_by_card_id(card.id)
    if existing_candidate
      existing_candidate.update_from_card(card)
    else
      candidates << Candidate.build_from_card(card)
    end
  end

  def final_states
    states.final
  end

  def contains_state?(name)
    states.where(name: name).count > 0
  end
end
