
class MessengerBot
    RECEIPT_TEMPLATE_BODY = {
      "attachment":{
        "type": "template",
        "payload":{
          "template_type": "receipt",
          "recipient_name": "",
          "order_number": "12345678902",
          "currency": "INR",
          "payment_method": "Cash On Delivery",        
          "order_url": "http://petersapparel.parseapp.com/order?order_id=123456",
          "timestamp": "",         
          "address":{
            "street_1": "1 Hacker Way",
            "street_2": "",
            "city": "",
            "postal_code": "",
            "state": "TN",
            "country": "IN"
          },
          "summary":{
            "subtotal": 75.00,
            "shipping_cost": 20.00,
            "total_tax": 5,
            "total_cost": 56.14
          },
          # "adjustments":[
          #   {
          #     "name": "Delivery charges",
          #     "amount": 20
          #   },
          #   {
          #     "name": "GST tax",
          #     "amount": 10
          #   }
          # ],
          "elements":[
            {
              "title": "Classic White T-Shirt",
              "subtitle": "100% Soft and Luxurious Cotton",
              "quantity": 2,
              "price": 50,
              "currency": "INR",
              "image_url": "http://petersapparel.parseapp.com/img/whiteshirt.png"
            },
            {
              "title": "Classic Gray T-Shirt",
              "subtitle": "100% Soft and Luxurious Cotton",
              "quantity": 1,
              "price": 25,
              "currency": "INR",
              "image_url": "http://petersapparel.parseapp.com/img/grayshirt.png"
            }
          ]
        }
      }
    }
end