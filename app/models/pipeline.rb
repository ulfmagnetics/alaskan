class Pipeline < ActiveRecord::Base
  attr_accessible :board_id, :last_synced_at, :name

  has_many :candidates
  has_many :states

  def self.states_that_look_final
    @@states_that_look_final ||= %w{ Rejected Hired }
  end

  def self.build_from_board(board)
    Pipeline.where(board_id: board.id).first_or_initialize.tap do |pipeline|
      Rails.logger.info "Building pipeline from board #{board.name} [#{board.id}]..."

      pipeline.name = board.name
      pipeline.last_synced_at = Time.now

      Rails.logger.info "Lists..."
      board.lists.each do |list|
        Rails.logger.info "  --> #{list.name}"
        unless pipeline.contains_state?(list.name)
          pipeline.states.build(name: list.name, final: states_that_look_final.include?(list.name))
        end
      end

      Rails.logger.info "Cards..."
      cards = board.cards.slice((ENV['START'] || 0).to_i, (ENV['LENGTH'] || board.cards.size).to_i)
      cards.each do |card|
        Rails.logger.info "  --> #{card.name}"
        pipeline.sync_candidate(card)
      end

      Rails.logger.info "... Done."
    end
  end

  def sync_candidate(card)
    existing_candidate = candidates.find_last_by_card_id(card.id)
    if existing_candidate
      existing_candidate.update_from_card(card)
    else
      Candidate.build_from_card(card, final_states).tap do |candidate|
        if candidate && candidate.valid?
          candidates << candidate
        else
          Rails.logger.error "Couldn't build candidate for card: #{card.inspect}"
        end
      end
    end
  end

  def final_states
    states.final
  end

  def contains_state?(name)
    states.where(name: name).count > 0
  end
end
