class Pipeline < ActiveRecord::Base
  attr_accessible :board_id, :last_synced_at, :name

  has_many :candidates
  has_many :states

  FINAL_STATE_NAMES = %w{ Rejected Hired }

  def self.build_from_board(board)
    Pipeline.where(board_id: board.id).first_or_initialize.tap do |pipeline|
      pipeline.name = board.name
      pipeline.last_synced_at = Time.now
      board.lists.each do |list|
        unless pipeline.contains_state?(list.name)
          pipeline.states.build(name: list.name, final: FINAL_STATE_NAMES.include?(list.name))
        end
      end
    end
  end

  def final_states
    # pipeline_stages.final.collect
  end

  def contains_state?(name)
    states.where(name: name).count > 0
  end
end
