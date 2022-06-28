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
  # Have the user redirected to the greetings index page
  redirect "/greetings"
end

get "/greetings" do 
  # Read the csv file and store it to an instance variable, so it will be available in the view
  @greetings = CSV.readlines("greetings.csv", headers: true)
  
  # Render the index page for this path
  erb :index
end

get '/greetings/new' do
  # Render the new page which contains the form
  erb :new
end

# Handle the POST request when the form is submitted
post '/greetings' do
  # Extract the relevant data from params
  new_greeting = params[:greeting_name]
  new_greeting_loudness = params[:greeting_loudness]

  # Open the CSV file with a second argument of "a" to append to the file
  CSV.open("greetings.csv", "a") do |csv|
    # Add the data as one element in the correct order depending on the headers in greetings.csv
    csv << [new_greeting, new_greeting_loudness]
  end

  # Redirect and "erb :index", so that the page will read from the CSV file and display the new entry.
  redirect "/greetings"
end
