# @author Balaji
class MessengerBot

	# Supported Languages
	SUPPORTED_LANGUAGE = {
		"en" => "default",
		"ta" => "ta_IN"
	}


	# Greeting Text:
	GREETING_MESSAGE = {
		"en" => "Hey #{@first_name} #{@last_name} welcome to Food2Home. I am here to assist you on food ordering.",
		"ta" => "வணக்கம்!"
	}

	# Quick reply header text:
	QUICK_REPLY_HEADER = {
		"en" => "How can I help you?",
		"ta" => "நான் உங்களுக்கு ஏவ்வாறு உதவ வேண்டும்?"
	}

	# Quick reply option texts:
	QUICK_REPLY_OPTIONS = {
		"MENU" => {
			"en" => "உணவு பட்டியல்",
			"ta" => "செய்திகள்" 
		},
		"VIEW_MY_CART" => {
			"en" => "View My Cart",
			"ta" => "எனது பட்டியலைக் காட்டு"
		},
		"HELP" => {
 			"en" => "Help",
 			"ta" => "உதவி"
 		}
	}

	# Error message - Can't understand users message texts:
	CANT_UNDERSTAND_MESSAGE = {
		"en" => "Sorry, I couldn't understand that.",
		"ta" => "மன்னிக்கவும், எனக்கு புரியவில்லை."
	}
end