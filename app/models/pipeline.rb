class Pipeline < ActiveRecord::Base
  attr_accessible :board_id, :last_synced_at, :name

  has_many :candidates

  def self.build_from_board(board)
    Pipeline.where(board_id: board.id).first_or_initialize.tap do |pipeline|
      pipeline.name = board.name
      pipeline.last_synced_at = Time.now
    end
  end

  def final_states
  end
end
