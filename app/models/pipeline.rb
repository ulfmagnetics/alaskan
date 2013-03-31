class Pipeline < ActiveRecord::Base
  attr_accessible :board_id, :last_synced_at, :name

  # TODO add final_states - array of states that represent an exit from the pipeline

  has_many :candidates
end
