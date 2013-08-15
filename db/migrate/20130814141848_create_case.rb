class CreateCase < ActiveRecord::Migration
  def up
	create_table :cases do |t|
		t.string :tags
		t.text :code	
		t.timestamps
	end
  end

  def down
	drop_table :cases
  end
end
