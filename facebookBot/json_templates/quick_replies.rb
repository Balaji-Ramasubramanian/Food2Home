# @author Balaji
class MessengerBot

 # quick replies object
 QUICK_REPLIES = [
    {
      "content_type": 'text',
      "title": 'Menu',
      "payload": 'MENU'
    },
    {
      "content_type": 'text',
      "title": 'View my cart',
      "payload": 'VIEW_MY_CART'
    },
    {
      "content_type": 'text',
      "title": 'Help',
      "payload": 'HELP'
    }
  ]

  # Quick reply with location option
  QUICK_REPLIES_LOCATION = [
    {
      "content_type": 'location'
    }
  ]

  # quick reply with place order options
  QUICK_REPLIES_ORDER = [
    {
    "content_type": 'text',
    "title": 'Place Order',
    "payload": 'ORDER'
    },
    {
    "content_type": 'text',
    "title": 'Add more food',
    "payload": 'ADD_MORE_FOOD'
    }
  ]

  # quick reply for confirmation of the order
  QUICK_REPLIES_CONFIRM_ORDER = [
    {
    "content_type": 'text',
    "title": 'Confirm Order',
    "payload": 'CONFIRM_ORDER'
    },
    {
      "content_type": 'text',
      "title": 'Cancel Order',
      "payload": 'CANCEL_ORDER'
    },
    {
      "content_type": 'text',
      "title": 'Edit PhoneNumber',
      "payload": 'EDIT_PHONE_NUMBER'
    },
    {
      "content_type": 'text',
      "title": 'Edit Address',
      "payload": 'EDIT_ADDRESS'
    }
  ]
end
