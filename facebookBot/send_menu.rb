require_relative './menu'
require_relative './bot'

class MessengerBot

	def self.send_menu(id)
		template = GENERIC_TEMPLATE_BODY
		elements = []
		(0..9).each { |i|
			break if i > MENU_ITEMS.length-1
			title =  MENU_ITEMS[i]["title"]
			text = MENU_ITEMS[i]["text"]
			image_url = MENU_ITEMS[i]["image_url"]
			new_element = {
					"title": title,
		            "subtitle": text,
		            "image_url": image_url,
		            "buttons":[
		            	{
		              		"type": "postback",
		              		"title": "Add to cart",
		              		"payload": "ADD_TO_CART_#{title}"
		            	}
		            ]
		    }
		    elements << new_element		
		}
		template[:attachment][:payload][:elements] = elements
		post_template(id,template)
	end

	def self.post_template(id,template)
		message_options = {
		"messaging_type": "RESPONSE",
        "recipient": { "id": "#{id}"},
        "message": "#{template.to_json}"
        }
		res = HTTParty.post(FB_MESSAGE, headers: HEADER, body: message_options.to_json)
	end

end