require 'sinatra'
require 'sinatra/reloader'
require 'pry'
require "csv"

configure :development, :test do
  require 'pry'
end

Dir[File.join(File.dirname(__FILE__), 'lib', '**', '*.rb')].each do |file|
  require file
  also_reload file
end

# ------

get "/" do 
  redirect "/greetings"
end

get "/greetings" do 
  @greetings = CSV.readlines("greetings.csv", headers: true)
    
  erb :index
end

get '/greetings/new' do
  erb :new
end

post '/greetings' do
  new_greeting = params[:greeting_name]
  new_greeting_loudness = params[:greeting_loudness]

  CSV.open("greetings.csv", "a") do |csv|
    csv << [new_greeting, new_greeting_loudness]
  end

  redirect "/greetings"
end
