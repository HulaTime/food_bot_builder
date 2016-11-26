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
      bot.api.send_message(chat_id: message.chat.id, text: 'Input Ingredients')
  	  updates = HTTParty.get(T_URL)
  	  count = updates['result'].length
      loop do
  		  if HTTParty.get(T_URL)['result'].length != count
          if HTTParty.get(T_URL)['result'][-1]['message']['text'].include?(' ')
            user_input = HTTParty.get(T_URL)['result'][-1]['message']['text'].gsub!(' ','%20')
          else
            user_input = HTTParty.get(T_URL)['result'][-1]['message']['text']
          end
          h = HTTParty.get((F_URL+"&q=#{user_input}"))
          kb = []
          h['hits'].each do |hit|
  				  text = hit['recipe']['label']
            recipe_url = hit['recipe']['url']
            kb << Telegram::Bot::Types::InlineKeyboardButton.new(text: text, url: recipe_url)
  			  end
          markup = Telegram::Bot::Types::InlineKeyboardMarkup.new(inline_keyboard: kb)
          bot.api.send_message(chat_id: message.chat.id, text: 'Choose Recipe', reply_markup: markup)
  			break
        end
  		end

    end
  end
end
