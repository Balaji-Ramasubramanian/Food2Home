class MessengerBot
  
  PERSISTENT_MENU = {
    "persistent_menu": [
      {
        "locale": "default",
        "composer_input_disabled": false,
        "call_to_actions": [
          {
            "title": "Menu",
            "type": "postback",
            "payload": "MENU"
          },
          {
            "title": "View My Cart",
            "type": "postback",
            "payload": "VIEW_MY_CART"
          },
          {
            "title": "Status of my order",
            "type": "postback",
            "payload": "STATUS_OF_MY_ORDER"
          }
        ]
      }
    ]
  }

end