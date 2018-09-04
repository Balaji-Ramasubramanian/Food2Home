require_relative './bot'
require_relative './send_menu'
require_relative './json_templates/receipt_template'

class MessengerBot

	def self.send_receipt(id)
		profile_details = get_profile(id)
		template = RECEIPT_TEMPLATE_BODY
		cart = Cart.find_by_facebook_userid(id)
		if cart.items_in_the_cart != nil then
			template[:attachment][:payload][:recipient_name] = profile_details["first_name"] +" "+ profile_details["last_name"]	
			template[:attachment][:payload][:order_number] = id
			template[:attachment][:payload][:timestamp] = Time.now.to_i
			subtotal_cost = find_total_cost(id)
			total_tax = subtotal_cost.to_i * 0.05
			shipping_cost = 20
			address = cart.full_address.split(",")
			street_1 = address[0]
			city = address[1]
			postal_code = address[2]
			phone_number = cart.phone_number
			elements = get_cart_elements(id)
			template[:attachment][:payload][:elements] = elements
			template[:attachment][:payload][:summary][:subtotal] = subtotal_cost
			template[:attachment][:payload][:summary][:shipping_cost] = shipping_cost
			template[:attachment][:payload][:summary][:total_tax] = total_tax
			template[:attachment][:payload][:address][:street_1] = street_1
			template[:attachment][:payload][:address][:city] = city
			template[:attachment][:payload][:address][:postal_code] = postal_code
			template[:attachment][:payload][:summary][:total_cost] = subtotal_cost.to_i + total_tax.to_i + shipping_cost.to_i 
			post_template(id,template)
			cart.status = "Preparing"
		end
		cart.save
	end

	def self.show_status(id)
		cart = Cart.find_by_facebook_userid(id)
		status = cart.status
		if status != nil then
			template = GENERIC_TEMPLATE_BODY
			buttons = [
			            	{
			              		"type": "postback",
			              		"title": "Cancel Order",
			              		"payload": "CANCEL_ORDER"
			            	}
			        ]
			element = [{
						"title": "Order Number " + "#{id}",
			            "subtitle": "Status: "+ status
			 		}]
			element[0]["buttons"] = buttons if status == "Preparing"
		    template[:attachment][:payload][:elements] = element
		    say(id,"Here is your order details")
		    post_template(id,template)
		else
			say(id,"There is no order is pending!")
		end
	end

	def self.find_total_cost(id)
		cart = Cart.find_by_facebook_userid(id)
		items_in_the_cart = cart.items_in_the_cart
		items = items_in_the_cart.split(",") if items_in_the_cart != nil
		total_cost = 0
		items.each do |i|
				item_elements = i.split("-")
				total_cost += item_elements[2].to_i
		end
		return total_cost
	end

	def self.get_cart_elements(id)
		elements = []
		cart = Cart.find_by_facebook_userid(id)
		items_in_the_cart = cart.items_in_the_cart
		items = items_in_the_cart.split(",") if items_in_the_cart != nil
		items.each do |i|	
			item_elements = i.split("-")
			image_url = get_image_url(item_elements[0])
			subtitle = get_item_text(item_elements[0])
			new_element = {
              "title": item_elements[0],
              "subtitle": subtitle,
              "quantity": item_elements[1],
              "price": item_elements[2],
              "currency": "INR",
              "image_url": image_url
          	}
          	elements << new_element
        end
        return elements
	end

	def self.get_image_url(item_name)
		image_url = nil
		MENU_ITEMS.each do |i|
			image_url = i["image_url"] if i["title"] == item_name
		end
		return image_url
	end

	def self.get_item_text(item_name)
		text = ""
		MENU_ITEMS.each do |i|
			text = i["text"] if i["title"] == item_name
		end
		return text
	end
end