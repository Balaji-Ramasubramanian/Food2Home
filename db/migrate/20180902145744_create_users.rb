class CreateUsers < ActiveRecord::Migration[5.2]
  def up
  	create_table :users do |t|
  		t.string :facebook_userid
      t.string :first_name
      t.string :last_name
  		t.string :locale
  		t.string :step_number
    end
  end

  def down
  	drop_table :users
  end

end
