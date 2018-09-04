require_relative './bot'
require_relative './send_menu'

class MessengerBot

	def self.show_cart(id)
		template = GENERIC_TEMPLATE_BODY
		elements = []
		cart = Cart.find_by_facebook_userid(id)
		items_in_the_cart = cart.items_in_the_cart
		items = items_in_the_cart.split(",") if items_in_the_cart != nil
		if items == nil then
		 	say(id,"Your cart is empty")
		 elsif cart.status != nil then
		 	say(id,"Your Order is being preparing. We will delivered to you shortly!")
		else 
			(0..9).each { |i|
				break if i > items.length-1
				item = items[i].split("-")
				title =  item[0]
				image_url = ""
				MENU_ITEMS.each do |menu_item|
					image_url = menu_item["image_url"] if menu_item["title"] == title
				end
				text = "Qty = #{item[1]} \n Cost = Rs. #{item[2]}"
				new_element = {
					"title": title,
		            "subtitle": text,
		            "image_url": image_url,
		            "buttons":[
		            	{
		              		"type": "postback",
		              		"title": "Remove from cart",
		              		"payload": "REMOVE_FROM_CART_#{title}"
		            	},
		            	{
		              		"type": "postback",
		              		"title": "Edit Quantity",
		              		"payload": "EDIT_QUANTITY_#{title}"
		            	}
		            ]
		    	}
		    	elements << new_element		
			}
			template[:attachment][:payload][:elements] = elements
			post_template(id,template)
			ask_confirmation(id)
		end
	end

	def self.ask_confirmation(id)
		send_quick_reply(id,"Would you like to place the order?",QUICK_REPLIES_ORDER)
	end
end