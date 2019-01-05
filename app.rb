require 'sinatra'
require 'sinatra/activerecord'
require 'rake'
require 'dotenv/load'

# Talk to Facebook
get '/webhook' do
  params['hub.challenge'] if ENV["VERIFY_TOKEN"] == params['hub.verify_token']
end

#Show nothing in the browser
get "/" do
  erb :home
end

get "/google84c3dbeaf9f4db10.html" do
	erb :google_verify
end