class CreateCase < ActiveRecord::Migration
  def up
	create_table :cases do |t|
		t.string :name
		t.string :tags
		t.text :comment
		t.text :input
		t.text :code	
		t.timestamps
	end
  end

  def down
	drop_table :cases
  end
end
