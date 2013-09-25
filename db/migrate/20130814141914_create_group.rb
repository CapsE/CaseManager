class CreateGroup < ActiveRecord::Migration
  def up
	create_table :groups do |t|
		t.string :name
		t.string :tags
		t.text :comment
		t.text	:elements
		t.integer :level
		t.timestamps
	end
  end

  def down
	drop_table :groups
  end
end
