class Pipeline < ActiveRecord::Base
  attr_accessible :board_id, :last_synced_at, :name

  has_many :candidates
end
