class CreateCandidates < ActiveRecord::Migration
  def change
    create_table :candidates do |t|
      t.integer :pipeline_id
      t.string :card_id
      t.string :name
      t.string :role
      t.date :entry_date
      t.date :exit_date
      t.string :exit_state
      t.string :current_state

      t.timestamps
    end

    add_index :candidates, :card_id
  end
end
