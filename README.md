# Food2Home [![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)
This is a Facebook Messenger chatbot template for restaurants. Restaurants can make use of this project and they can deploy it in their own servers to provide their service.

## Overview
Using this bot the users can do the following,
- View the menu
- Add/remove food to cart
- View the receipt
- Track their order

## How a user can use the bot?
> **Note:** This chatbot is currently in development phase, So before start using this chatbot, you need to be in the testers list of this bot. Just send an E-mail to balaji030698@gmail.com with your Facebook profile URL, I will add you to the testers list. You will get an invite notification through Facebook. After accepting the invitation, You can start using this bot.

> Once the chatbot is published, Every Facebook user can access it without requesting for the test user access.

The demo chatbot is currently deployed in the page https://www.facebook.com/Food2HomeBot

- Open the url https://m.me/Food2HomeBot.
- Click on the *GET STARTED* button to start the conversation.
- You can use the menu present in the chat to send messages quickly.


Since this bot using Natural Language Processing(NLP), The users can converse with the bot using their own phrases.

The sample phrases that users can use,
- Show me the menu
- Add five Pizzas to the cart
- Show me my cart
- Remove burger from cart 
- Can you show me the menu?
- Place this order
- Show me the receipt
- What is the status of my order?

# For developers

## Requirements to deploy this chatbot
- Ruby
- MySQL Database
- Online hosting server
- Wit Project (For Natural Language Processing)

## Getting started
First, you'll need to fork and clone this repo

Open Terminal. Change the current working directory to the location where you want the cloned directory to be created.

```
git clone https://github.com/Balaji-Ramasubramanian/Food2Home
```
Let's get all our dependencies setup:
```
 bundle install 
```

## Configuration
You need to change the **.env** file with your appropriate access tokens, usernames, and passwords. You need to add the following details,
- Facebook page access token
- Verify token for your Facebook app
- App secret token
- Wit access token
- Database Host
- Database Name
- Database Username
- Database Password

## Migrate database
First, you'll need to migrate the database tables
```
rake db:migrate
```

## Deploying your app:

#### Test your project locally
Download [ngrok](https://ngrok.com) in your local system.

Open terminal and navigate to the project folder

run `rackup -p <port_number>`.

Open another window in terminal 

run `<path_of_ngrok_file> http <port_number>`

copy the URL with 'https://' prefix. This is your webhook URL that serves your program.


#### Deploying with Heroku:
You need to have Heroku CLI installed to deploy the bot in Heroku. To find more details about Heroku CLI, [click here](https://devcenter.heroku.com/articles/heroku-cli).

You can follow [this link](https://devcenter.heroku.com/articles/git) to setup the Heroku environment for the project.

For this project, you need the following resources in your Heroku project,
- ClearDB MySQL :: Database
- Heroku Scheduler


I will update the instructions for deploying the app in AWS, Google Cloud and Microsoft Azure shortly.

## Create an app in Facebook
- Goto [developers.facebook.com](https://developers.facebook.com.)
- Login using your Facebook account username and password.
- Select 'Add New App' under 'My Apps' section.
- Give a suitable name for you bot and click submit.
- Click 'set up' in Messenger product. Within the Messenger product, Select the page you want to add this chatbot and setup webhook.

#### Add webhook URL to your Facebook App
In [developers.facebook.com](https://developers.facebook.com.), Navigate to your app's dashboard and click 'webhook' under products section.
Click 'Edit subscription' button and Paste the Webhook URL over there. 

**Note** Don't forget to append '/webhook' after the URL (since config.ru file mapped to the path '/webhook').
```
https://<YOUR_URL>>/webhook
```
Or you can modify your config.ru file in your project to map whatever URL path you want.

## How to add test users?
### Test the app during the development phase
During the development phase, only the admins of the bot and the test users who are added by the admins are able to use the bot.
Admins of the chatbot can add more Facebook users and also add test users through their app's dashboard.

#### Add new roles to the bot
To add new roles, Navigate to the app's dashboard on [Facebook developer's page](https://developers.facebook.com/apps/).
Click on Roles -> Roles.
In this page, we can add Facebook users to any one of the roles of admin/developer/tester/analytic user.

#### Add test users
Test Users are temporary Facebook accounts that you can create to test various features of your app.
To add test users for your app, Navigate to Roles -> Test Users and click on add/edit test user accounts.

## Publishing the app
To publish the chatbot, we need to submit our app for Facebook review.
To do that, click on App Review -> start a submission.

After publishing the app, any Facebook users can access it by directly sending messages to the corresponding Facebook page that hosts the chatbot.

## Contribute
#### Simple 3 step to contribute to this repo:
1. Fork the project.
2. Make required changes and commit.
3. Generate a pull request. Mention all the required description regarding the changes you have made.

## Author 
#### Balaji Ramasubramanian
If you need any help in customizing and deploying this project, email me @ balaji030698@gmail.com

## License
Copyright 2018 Balaji Ramasubramanian

Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License. You may obtain a copy of the License at

http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License.
