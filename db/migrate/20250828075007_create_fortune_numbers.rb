class CreateFortuneNumbers < ActiveRecord::Migration[8.0]
  def change
    create_table :fortune_numbers do |t|
      t.integer :number, null: false

      t.timestamps
    end
    
    add_index :fortune_numbers, :number, unique: true
  end
end
