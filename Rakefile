require './app'
require 'rake'
require 'sinatra/activerecord/rake'
require 'sinatra/activerecord'
require 'httparty'
require 'json'
require 'date'

task :hit_url do
	# Hits the url provided inorder to keep the heroku app up and running
	res = HTTParty.get("https://food2home-bot.herokuapp.com/")
end