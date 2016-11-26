require 'dotenv'
Dotenv.load
require 'telegram/bot'
require 'httparty'

T_URL = "https://api.telegram.org/bot"+ENV['AUTH_TOKEN']+"/getupdates"
F_URL = "https://api.edamam.com/search?app_id="+ENV['FOOD_ID']+"&app_key="+ENV['FOOD_KEY']

Telegram::Bot::Client.run(ENV['AUTH_TOKEN']) do |bot|
  bot.listen do |message|
    case message.text

    when '/start'
      bot.api.send_message(chat_id:message.chat.id, text: "Hello, #{message.from.first_name}")
    
    when '/recipes'
  	  updates = HTTParty.get(T_URL)
  	  count = updates['result'].length
  	  bot.api.send_message(chat_id: message.chat.id, text: count)
      loop do
  		  if HTTParty.get(T_URL)['result'].length != count
  			  bot.api.send_message(chat_id: message.chat.id, text: (HTTParty.get(T_URL)['result'].length))
          ingredient = HTTParty.get(T_URL)['result'][-1]['message']['text']
          bot.api.send_message(chat_id: message.chat.id, text: ingredient)
          h = HTTParty.get((F_URL+"&q=#{ingredient}"))
  			  
          h['hits'].each do |hit| 
  				  text = hit['recipe']['url']
  				  bot.api.send_message(chat_id: message.chat.id, text: text)
  			  end            
  			break
        end
  		end
    
    end	
  end
end

