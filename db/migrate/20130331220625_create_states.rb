class CreateStates < ActiveRecord::Migration
  def change
    create_table :states do |t|
      t.string :name
      t.integer :pipeline_id
      t.boolean :final

      t.timestamps
    end
  end
end
