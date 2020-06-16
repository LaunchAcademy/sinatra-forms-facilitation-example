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

get "/greetings" do
  @greetings = CSV.readlines("greetings.csv")

  erb :index
end

get '/greetings/new' do
  erb :new
end

post '/greetings' do
  new_message = params[:message_body]
  new_message_type = params[:message_type]


  CSV.open("greetings.csv", "a") do |csv|
    csv << [new_message, new_message_type]
  end

  redirect '/greetings'
end
