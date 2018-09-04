class MessengerBot

 QUICK_REPLIES = [
    {
      "content_type": 'text',
      "title": 'Menu',
      "payload": 'MENU'
    }
  ]


  QUICK_REPLIES_LOCATION = [
    {
      "content_type": 'location'
    }
  ]


  QUICK_REPLIES_ORDER = [
    {
    "content_type": 'text',
    "title": 'Make this Order',
    "payload": 'ORDER'
    },
    {
    "content_type": 'text',
    "title": 'Add more food',
    "payload": 'ADD_MORE_FOOD'
    }
  ]

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
