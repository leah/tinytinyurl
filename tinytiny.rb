#tinytiny.rb
# My first Ruby/Sinatra app, a URL shortener.
# by Leah Culver (http://github.com/leah)
require 'rubygems'
require 'sinatra'
require 'sequel'

# Base36 encoded
BASE = 36

configure do
  DB = Sequel.sqlite
  DB.create_table :tinyurls do
    primary_key :id
    String :url
  end
end

get '/' do
  # Form for entering a fatty URL
  <<-end_form
  <h1>Tiny tiny URLs!</h1>
  <form method='post'>
    <input type="text" name="url">
    <input type="submit" value="Make it tiny!">
  </form>
  end_form
end

post '/' do
  # Put the fatty URL in the database and display
  items = DB[:tinyurls]
  id = items.insert(:url => params[:url])
  url = request.url + id.to_s(BASE)
  "Your tiny tiny url is: <a href='#{url}'>#{url}</a>"
end

get '/:tinyid' do
  # Resolve the tiny URL
  items = DB[:tinyurls]
  id = params[:tinyid].to_i(BASE)
  url = items.first(:id => id)
  redirect url[:url]
end