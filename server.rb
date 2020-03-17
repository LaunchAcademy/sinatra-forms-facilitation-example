require 'sinatra'
require 'sinatra/reloader'
require "csv"

configure :development, :test do
  require 'pry'
end

Dir[File.join(File.dirname(__FILE__), 'lib', '**', '*.rb')].each do |file|
  require file
  also_reload file
end

get "/tasks" do
  @tasks = CSV.readlines("tasks.csv", headers:true)

 erb :index
end

get '/tasks/new' do
  erb :new
end

post '/tasks' do
  task_name = params[:task_name]

  CSV.open("tasks.csv", "a") do |csv|
    csv << [task_name]
  end

  redirect "/tasks"
end
