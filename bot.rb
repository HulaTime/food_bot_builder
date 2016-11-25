require 'dotenv'
Dotenv.load
require 'telegram/bot'
require 'httparty'
url = "https://api.edamam.com/search?q=chicken&app_id="+ENV['EDAMAM_APP_ID']+"&app_key="+ENV['EDAMAM_APP_KEY']+"&from=0&to=3&calories=gte%20591,%20lte%20722&health=alcohol-free"
token = ENV['AUTH_TOKEN']

Telegram::Bot::Client.run(token) do |bot|
  bot.listen do |message|
  	print message
    case message.text
    when '/chickenrecipes'
      url = "https://api.edamam.com/search?q=chicken&app_id="+ENV['EDAMAM_APP_ID']+"&app_key="+ENV['EDAMAM_APP_KEY']+"&from=0&to=3&calories=gte%20591,%20lte%20722&health=alcohol-free"
    	HTTParty.get(url)
    	text = h['hits'].each do |hit| 
    		text = hit['recipe']['url']
    		bot.api.send_message(chat_id: message.chat.id, text: text)
    	end
    end
  end
end

