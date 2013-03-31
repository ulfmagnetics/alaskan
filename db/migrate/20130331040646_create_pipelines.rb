class CreatePipelines < ActiveRecord::Migration
  def change
    create_table :pipelines do |t|
      t.string :name
      t.string :board_id
      t.date :last_synced_at

      t.timestamps
    end
  end
end
