class Cart < ActiveRecord::Migration[5.2]
  def up
  	create_table :carts do |t|
  		t.string :facebook_userid
  		t.string :items_in_the_cart
      t.string :phone_number
      t.string :full_address
  		t.string :order_status
    end
  end

  def down
  	drop_table :carts
  end
end
