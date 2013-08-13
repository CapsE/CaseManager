class CreateThing < ActiveRecord::Migration
  def up
	create_table :things do |t|
		t.string :title
		t.text :body
		t.integer :number
		t.timestamps
	end
  end

  def down
    drop_table :things
  end
end
