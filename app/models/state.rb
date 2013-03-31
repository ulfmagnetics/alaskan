class State < ActiveRecord::Base
  attr_accessible :name, :final, :pipeline_id

  belongs_to :pipeline

  scope :final, where(final: true)
end
