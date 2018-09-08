require_relative './bot'

# @author Balaji
class MessengerBot

 	# @param id [Integer] The Facebook User ID.
 	# @return [nil].
 	# Method to get address details from the user.
 	#
	def self.get_address_details(id)
		say(id,"Enter your phone number")
		cart = Cart.find_by_facebook_userid(id)
		user = User.find_by_facebook_userid(id)
		if cart == nil then
			say(id,"Error!")
		else
			user.step_number = "3_phone_number"
		end
		user.save
	end

 	# @param recipient_id [Integer] The Facebook User ID.
 	# @param text [String] text want to be delivered to user.
 	# @return [nil].
 	# Method to show confirmation message to the user.
 	#
	def self.show_confirmation_message(id)
		send_quick_reply(id,"Are you sure to place this Order?",QUICK_REPLIES_CONFIRM_ORDER)
	end

 	# @param id [Integer] The Facebook User ID.
 	# @return [nil].
 	# Method to cancel the user's food order. It makes cart items of the user as NULL.
 	#
	def self.cancel_order(id)
		user = User.find_by_facebook_userid(id)
		user.step_number = "0"
		cart = Cart.find_by_facebook_userid(id)
		cart.items_in_the_cart = nil
		cart.order_status = nil
		cart.save
		user.save
	end
end