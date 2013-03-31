class Pipeline < ActiveRecord::Base
  attr_accessible :board_id, :last_synced_at, :name

  # TODO add exit_state attribute

  has_many :candidates
end
