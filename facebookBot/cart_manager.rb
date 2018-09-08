require_relative './bot.rb'

# @author Balaji
class MessengerBot

 	# @param id [Integer] The Facebook User ID.
 	# @param item [String] Food item which quantity value to be asked to the user.
 	# @return [nil].
 	# This metod is used to ask quantiy of a food item to the user.
 	#
	def self.ask_quantity(id,item)
		user = User.find_by_facebook_userid(id)
		if user != nil then
			user.step_number = "1_#{item}"
			user.save
			say(id,"How many #{item}s you need?")
		end
	end

 	# @param id [Integer] The Facebook User ID.
 	# @param item_to_add [String] The food item that to be added in the cart.
 	# @return [nil].
 	# Mehod to add a item to the cart
 	#
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
					if item_elements[0] == item_to_add then 
						old_item = true 
						old_quantity = item_elements[1] 
						quantity = old_quantity.to_i + quantity.to_i 
					end
				end
			end
			
			if old_item then 
				edit_quantity(id,item_to_add,quantity.to_s)
			else
				cart.items_in_the_cart +=  "," + "#{item_to_add}-#{quantity}-#{total_price}" if cart.items_in_the_cart != nil
				cart.items_in_the_cart = "#{item_to_add}-#{quantity}-#{total_price}" if cart.items_in_the_cart == nil
				cart.order_status = nil if cart.order_status == "Preparing"
				cart.save
				user = User.find_by_facebook_userid(id)
				user.step_number = "0"
				user.save
				say(id,"#{quantity} #{item_to_add} is added to the cart! \nyou can confirm your order by clicking View my cart -> Place order \nOr continue adding food to cart")
			end
		else
			say(id,"The #{item_to_add} is not available right now! could you make any other order?")
			say(id,"Here is the menu,")
			user = User.find_by_facebook_userid(id)
			user.step_number = "0"
			user.save
			send_menu(id)
		end
	end

 	# @param id [Integer] The Facebook User ID.
 	# @param item_to_remove [String] The item to be removed from the cart.
 	# @param quantity [String] The quantity of the item to be removed.
 	# @return [nil].
 	# Method to remove item from the cart.
 	#
	def self.remove_item_from_cart(id,item_to_remove,quantity = "remove_all")
		cart = Cart.find_by_facebook_userid(id)
		items_in_the_cart = cart.items_in_the_cart
		items = items_in_the_cart.split(",") if items_in_the_cart != nil
		new_items = nil
		is_decremented = false
		qty_after_decremented = nil
		if items == nil then
			say(id,"Your cart is empty!")
		else
			items.each do |i|
				item_elements = i.split("-")
				new_items += "," + i if new_items != nil && item_elements[0] !=item_to_remove
				new_items = i if new_items == nil && item_elements[0] !=item_to_remove
				if  quantity != "remove_all" && item_elements[0] == item_to_remove then 
					item_elements[1] = item_elements[1].to_i - quantity.to_i
					qty_after_decremented = item_elements[1]
					i = item_elements[0] + "-" + item_elements[1].to_s + "-" + item_elements[2]
					new_items += "," + i if item_elements[1] > 0 && new_items != nil
					new_items = i if item_elements[1] > 0 && new_items == nil
					is_decremented = true
				end
			end
			cart.items_in_the_cart = new_items
			cart.order_status = nil if cart.order_status == "Preparing"
			cart.save
			say(id,"Okay, #{item_to_remove} removed from your cart!") if is_decremented == false || qty_after_decremented <0
			say(id,"Okay, Now you have #{qty_after_decremented} #{item_to_remove} in your cart") if is_decremented == true && qty_after_decremented >0
			
		end
	end

 	# @param id [Integer] The Facebook User ID.
 	# @param item_to_edit [String] The item which quantity to be edited.
 	# @param qty [String] The quantity of the item.
 	# @return [nil].
 	# Method to edit quantity of a food item.
 	#
	def self.edit_quantity(id,item_to_edit,qty)
		cart = Cart.find_by_facebook_userid(id)
		items_in_the_cart = cart.items_in_the_cart
		items = items_in_the_cart.split(",") if items_in_the_cart != nil
		new_items = nil
		if items == nil then
			say(id,"Your cart is empty!")
		else
			changed = false
			items.each do |i|
				item_elements = i.split("-")
				if item_elements[0] == item_to_edit then
					item_elements [2] = ((item_elements[2].to_i / item_elements[1].to_i) * qty.to_i).to_s
					i = item_elements[0] + "-" + qty.to_s + "-" + item_elements[2]
					changed = true
				end
				new_items += "," + i if new_items != nil
				new_items = i if new_items == nil
			end
			cart.items_in_the_cart = new_items
			cart.order_status = nil if cart.order_status == "Preparing"
			cart.save
			say(id,"Okay, Now you have #{qty} #{item_to_edit}s in your cart") if changed == true
			say(id,"Sorry, There is no #{item_to_edit} in your cart.") if changed == false
			show_cart(id)
			user = User.find_by_facebook_userid(id)
			user.step_number = "0"
			user.save
		end
	end


end