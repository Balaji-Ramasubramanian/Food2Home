require_relative './bot.rb'

class MessengerBot

	def self.ask_quantity(id,item)
		user = User.find_by_facebook_userid(id)
		if user != nil then
			user.step_number = "1_#{item}"
			user.save
			say(id,"How many #{item}s you need?")
		end
	end


	def self.add_item_to_cart(id,item_to_add,quantity)
		price = nil
		MENU_ITEMS.each do |i|
			if i["title"] == item_to_add then
				price = i["price"]
			end
		end
		total_price = quantity.to_i * price.to_i unless price == nil
		cart = Cart.find_by_facebook_userid(id)
		if price != nil then
			items_in_the_cart = cart.items_in_the_cart
			items = items_in_the_cart.split(",") if items_in_the_cart != nil
			old_item = false
			if items != nil then
				items.each do |i|
					item_elements = i.split("-")
					old_item = true if item_elements[0] == item_to_add
				end
			end
			
			if old_item then 
				edit_quantity(id,item_to_add,quantity.to_s)
			else
				cart.items_in_the_cart +=  "," + "#{item_to_add}-#{quantity}-#{total_price}" if cart.items_in_the_cart != nil
				cart.items_in_the_cart = "#{item_to_add}-#{quantity}-#{total_price}" if cart.items_in_the_cart == nil
				cart.save
				user = User.find_by_facebook_userid(id)
				user.step_number = "0"
				user.save
				say(id,"#{item_to_add} is added to the cart! \nyou can confirm your order by clicking View my cart -> Place order \nOr continue adding food to cart")
			end
		else
			say(id,"The #{item_to_add} is not available right now! could you make any other order?")
			send_menu(id)
		end
	end

	def self.remove_item_from_cart(id,item_to_remove)
		cart = Cart.find_by_facebook_userid(id)
		items_in_the_cart = cart.items_in_the_cart
		items = items_in_the_cart.split(",") if items_in_the_cart != nil
		new_items = nil
		if items == nil then
			say(id,"Your cart is empty!")
		else
			items.each do |i|
				item_elements = i.split("-")
				new_items += "," + i if new_items != nil && item_elements[0] !=item_to_remove
				new_items = i if new_items == nil && item_elements[0] !=item_to_remove
			end
			cart.items_in_the_cart = new_items
			cart.save
			say(id,"Okay, #{item_to_remove} removed from your cart!")
			# show_cart(id)
		end
	end

	def self.edit_quantity(id,item_to_edit,qty)
		cart = Cart.find_by_facebook_userid(id)
		items_in_the_cart = cart.items_in_the_cart
		items = items_in_the_cart.split(",") if items_in_the_cart != nil
		new_items = nil
		if items == nil then
			say(id,"Your cart is empty!")
		else
			items.each do |i|
				item_elements = i.split("-")
				if item_elements[0] == item_to_edit then
					item_elements [2] = ((item_elements[2].to_i / item_elements[1].to_i) * qty.to_i).to_s
					i = item_elements[0] + "-" + qty + "-" + item_elements[2]
				end
				new_items += "," + i if new_items != nil
				new_items = i if new_items == nil
			end
			cart.items_in_the_cart = new_items
			cart.save
			say(id,"#{item_to_edit} quantity changed as #{qty} in the cart")
			show_cart(id)
			user = User.find_by_facebook_userid(id)
			user.step_number = "0"
			user.save
		end
	end


end