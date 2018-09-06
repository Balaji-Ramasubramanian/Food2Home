require 'facebook/messenger'
require 'httparty'
require 'json'
require 'date'

require_relative '../utils'
require_relative '../wit/get_wit_message'
require_relative 'json_templates/greeting'
require_relative 'json_templates/persistent_menu'
require_relative 'json_templates/get_started'
require_relative 'json_templates/template'
require_relative 'json_templates/quick_replies'
require_relative 'json_templates/receipt_template'
require_relative '../models/user'
require_relative '../models/cart'
require_relative './menu'
require_relative './send_menu'
require_relative './send_receipt'
require_relative './show_cart'
require_relative './cart_manager'
require_relative './get_address'

include Facebook::Messenger

class MessengerBot

	# Method to create row in database user table
	def self.create_user(id)
		profile = get_profile(id)
		user = User.find_by_facebook_userid(id)
		if user == nil then
			user = User.new
			user.facebook_userid = id
			user.first_name = profile["first_name"]
			user.last_name = profile["last_name"]
			user.step_number = "0"
			user.locale = profile["locale"]
			user.save
			cart = Cart.new
			cart.facebook_userid = id
			cart.save
		end
	end

	#Method to get user Facebook profile details
	def self.get_profile(id)
 		fb_profile_url = FB_PROFILE + id + FB_PROFILE_FIELDS
 		profile_details = HTTParty.get(fb_profile_url)
 		@first_name = profile_details["first_name"]
 		@last_name = profile_details["last_name"]
 		@profile_pic = profile_details["profile_pic"]
 		@locale = profile_details["locale"]
 		@gender = profile_details["gender"]
 		return profile_details
 	end

 	#Method to push a message to Facebook
	def self.say(recipient_id, text)
		message_options = {
			messaging_type: "RESPONSE",
			recipient: { id: recipient_id },
			message: { text: text }
		}
		HTTParty.post(FB_MESSAGE, headers: HEADER, body: message_options)
	end

	#To send a quick reply to user
	def self.send_quick_reply(id,text,quick_reply)
		message_options = {
			messaging_type: "RESPONSE",
			recipient: { id: id},
			message: {
				text: text,
				quick_replies: quick_reply 
			}
		}
	 	response = HTTParty.post(FB_MESSAGE, headers: HEADER, body: message_options.to_json)

	 end

	#Typing indication:
	def self.typing_on(id)
		message_options = {
			messaging_type: "RESPONSE",
			recipient: { id: id },
			sender_action: "typing_on",
		}
		response = HTTParty.post(FB_MESSAGE,headers: HEADER, body: message_options.to_json)		
  	end


	#Initial configuration for the bot 
	Facebook::Messenger::Subscriptions.subscribe(access_token: ENV["FB_ACCESS_TOKEN"])
	greeting_response 		 =HTTParty.post(FB_PAGE,  headers: HEADER, body: GREETING.to_json )
	get_started_response	 =HTTParty.post(FB_PAGE,  headers: HEADER, body: GET_STARTED.to_json)
	persistent_menu_response =HTTParty.post(FB_PAGE, headers: HEADER, body: PERSISTENT_MENU.to_json)

	#Triggers whenever a message has got
	Bot.on :message do |message|
		id = message.sender["id"]
		message_text = message.text
		# if message.location_coordinates.size != 0 then
		# 	send_receipt(id)
		# end
		user = User.find_by_facebook_userid(id)
		step_number = user.step_number if user != nil

		if step_number.include?("1") then
			item = user.step_number.gsub("1_","")
			say(id,"Please enter the quantity in numbers alone!") unless message_text !~ /\D/
			add_item_to_cart(id,item,message_text) if message_text !~ /\D/

		elsif step_number.include?("2") then
			item = user.step_number.gsub("2_","")
			say(id,"Please enter the quantity in numbers alone!") unless message_text !~ /\D/
			edit_quantity(id,item,message_text) if message_text !~ /\D/

		elsif  step_number.include?("3") then
			say(id,"Please enter a valid phone number!") unless message_text  !~ /\D/ && message_text.length == 10
			if message_text  !~ /\D/ && message_text.length == 10 then
				phone_number = message_text
				cart = Cart.find_by_facebook_userid(id)
				cart.phone_number = phone_number
				cart.save
				user.step_number = "4_street_name"
				user.save
				say(id,"Please enter your Street name,")
			end

		elsif step_number.include?("4") then
			street = message_text
			cart = Cart.find_by_facebook_userid(id)
			cart.full_address = nil
			cart.full_address = street 
			cart.save
			user.step_number = "5_city_name"
			say(id,"Enter your city name")
			user.save

		elsif step_number.include?("5") then
			city = message_text
			cart = Cart.find_by_facebook_userid(id)
			cart.full_address += ","+city 
			cart.save
			user.step_number = "6_postal_code"
			say(id,"Enter Postal code ")
			user.save

		elsif step_number.include?("6") then
			say(id,"Please provide valid postal code") unless message_text  !~ /\D/
			if message_text  !~ /\D/ then
				postal_code = message_text 
				cart = Cart.find_by_facebook_userid(id)
				cart.full_address += ","+postal_code 
				cart.save
				user.step_number = "0"
				user.save
				show_confirmation_message(id)
			end
				
		elsif step_number.include?("edit_phone_number_alone") then
			say(id,"Please enter a valid phone number!") unless message_text  !~ /\D/ && message_text.length == 10
			if message_text  !~ /\D/ && message_text.length == 10 then
				phone_number = message_text
				cart = Cart.find_by_facebook_userid(id)
				cart.phone_number = phone_number
				cart.save
				user.step_number = "0"
				user.save
				say(id,"Done, Your phone number has been changed.")
				show_confirmation_message(id)
			end
							
		elsif message.quick_reply != nil
			call_postback(id,message.quick_reply)
		else
			call_message(id,message_text) if message.location_coordinates.size == 0
		end
	end

	#Triggers whenever a postback happens
	Bot.on :postback do |postback|
		id = postback.sender["id"]
		call_postback(id,postback.payload)
	end

	#Method to handle bot messages
	def self.call_message(id,message_text)
		typing_on(id)
		get_profile(id)
		case message_text.downcase
		when "hi"
			say(id,"Hi #{@first_name} #{@last_name} glad to see you!")
			send_quick_reply(id,"How can I help you?",QUICK_REPLIES)
		when "menu"
			say(id,"Here is the menu,")
			send_menu(id)
		else
			handle_wit_response(id,message_text)
		end
		
	end

	#Method to handle wit response
	def self.handle_wit_response(id,message_text)
		wit_response = Wit.new.get_intent(message_text)
		if wit_response.class == String then
			call_postback(id,wit_response)
		else
			handle_wit_entity(id,wit_response)
		end
	end

	#Method to handle postbacks
	def self.call_postback(id,postback_payload)
		typing_on(id)
		user = User.find_by_facebook_userid(id)
		case postback_payload
		when "GET_STARTED"
			get_profile(id)
			create_user(id)
			say(id,"Hey #{@first_name} #{@last_name} welcome to Food2Home. I am here to assist you on food ordering.")
			send_quick_reply(id,"How can I help you?",QUICK_REPLIES)
		when "HI"
			say(id,"Hi #{@first_name} #{@last_name} Glad to see you!")
			send_quick_reply(id,"How can I help you?",QUICK_REPLIES)
		when "MENU"
			say(id,"Here is the menu,")
			send_menu(id)
		when "OFFERS"
			say(id,"Currently no offers available. I'll tell you about offers if available")
		when "VIEW_MY_CART"
			show_cart(id)
		when "ORDER"
			cart = Cart.find_by_facebook_userid(id)
			if cart.items_in_the_cart == nil then
				send_menu(id)
			else
				get_address_details(id)
			end
		when "ADD_MORE_FOOD"
			say(id,"Sure! Here is the menu,")
			send_menu(id)
		when "CONFIRM_ORDER"
			cart = Cart.find_by_facebook_userid(id)
			say(id,"Your order is placed successfully! Here's the receipt,")
			send_receipt(id)
		when "CANCEL_ORDER"
			cancel_order(id)
			say(id,"Okay! The order is cancelled.")
		when "EDIT_PHONE_NUMBER"
			say(id,"Tell me your phone number")
			user = User.find_by_facebook_userid(id)
			user.step_number = "edit_phone_number_alone"
			user.save
		when "EDIT_ADDRESS"
			user = User.find_by_facebook_userid(id)
			user.step_number = "4_street_name"
			user.save
			say(id,"Please enter your street name,")
		when "STATUS_OF_MY_ORDER"
			cart = Cart.find_by_facebook_userid(id)
			if cart.order_status != nil then
				send_receipt(id)
				show_status(id)
			else
				say(id,"There is no pending order right now!")
			end
		when "HELP"
			say(id,"Hi, I'm a food ordering bot. I will help you to order food")
			say(id,"You can use phrases such as, \n->Show me the menu \n->Add five pizzas to my cart \n->Remove Burgers from the cart \n->Show me the cart")
		else
			handle_cart_postbacks(id,postback_payload)
		end
		user.step_number = "0" if user != nil
		user.save
	end

	def self.handle_cart_postbacks(id,postback_payload)
		if postback_payload.include?("ADD_TO_CART_") then
			item = postback_payload.gsub("ADD_TO_CART_","")
			ask_quantity(id,item)
		elsif postback_payload.include?("REMOVE_FROM_CART") then
			item = postback_payload.gsub("REMOVE_FROM_CART_","")
			remove_item_from_cart(id,item)
		elsif postback_payload.include?("EDIT_QUANTITY") then
			item = postback_payload.gsub("EDIT_QUANTITY_","")
			user = User.find_by_facebook_userid(id)
			user.step_number = "2_#{item}"
			say(id,"How many #{item}s you need?")
			user.save
		else
			say(id,"I can't understand that!")
			send_quick_reply(id,"How can I help you?",QUICK_REPLIES)
		end
	end

	def self.handle_wit_entity(id,entity)
		if entity.has_key?("intent") && entity.has_key?("item") && entity.has_key?("number") then
			quantity = entity["number"][0]["value"]
			if entity["intent"][0]["value"] == "ADD_TO_CART" then 
				item_to_add = entity["item"][0]["value"].split.map(&:capitalize).join(' ') # Capitalize every word in the string	
				add_item_to_cart(id,item_to_add,quantity)
			# elsif entity["intent"][0]["value"].include?("ADD_TO_CART_") then
			# 	item_to_add = entity["intent"][0]["value"].gsub("ADD_TO_CART_","")
			# 	item_to_add = item_to_add.split.map(&:capitalize).join(' ') 
			# 	add_item_to_cart(id,item_to_add,quantity)
			elsif entity["intent"][0]["value"].include?("EDIT_QUANTITY") then
				if entity.has_key?("item") then
					item_to_edit = entity["item"][0]["value"]
				else
					item_to_edit = entity["intent"][0]["value"].gsub("EDIT_QUANTITY_","")
				end
				item_to_edit = item_to_edit.split.map(&:capitalize).join(' ')
				edit_quantity(id,item_to_edit,quantity)
			elsif entity["intent"][0]["value"] == ("REMOVE_FROM_CART") then
				item_to_remove = entity["item"][0]["value"].split.map(&:capitalize).join(' ')
				quantity_to_remove = entity["number"][0]["value"]
				remove_item_from_cart(id,item_to_remove,quantity_to_remove)
			else
				say(id,"Couldn't understand that!")
			end

		elsif entity.has_key?("intent") && entity.has_key?("item") then
			if entity["intent"][0]["value"] == "ADD_TO_CART" then
				item_to_add = entity["item"][0]["value"].split.map(&:capitalize).join(' ')
				user = User.find_by_facebook_userid(id)
				user.step_number = "1_"+item_to_add
				user.save
				say(id,"Please enter the quantity of #{item_to_add} you want,")
			elsif entity["intent"][0]["value"] == "REMOVE_FROM_CART" then
				item_to_remove = entity["item"][0]["value"].split.map(&:capitalize).join(' ')
				remove_item_from_cart(id,item_to_remove)

			# elsif entity["intent"][0]["value"].include?("ADD_TO_CART_") && entity.has_key?("number") then
			# 	item_to_add = entity["intent"][0]["value"].gsub("ADD_TO_CART_","")
			# 	quantity = entity["number"][0]["value"]
			# 	add_item_to_cart(id,item_to_add,quantity)
			# elsif entity["intent"][0]["value"].include?("ADD_TO_CART_") then
			# 	item_to_add = entity["intent"][0]["value"].gsub("ADD_TO_CART_","")
			# 	ask_quantity(id,item_to_add)
			end

		else
			say(id,"Couldn't understand that!")
		end

	end

end