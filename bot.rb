require 'dotenv'
Dotenv.load
require 'telegram/bot'
require 'httparty'

t_url = "https://api.telegram.org/bot264986474:AAEFhtMdxFb-4e5ysvWfXNtTAGLnUF1exfQ/getupdates"
token = ENV['AUTH_TOKEN']

Telegram::Bot::Client.run(token) do |bot|
  bot.listen do |message|
    
    case message.text

    when '/recipes'

    	updates = HTTParty.get(t_url)
    	count = updates['result'].length
    	loop do
    		if HTTParty.get(t_url)['result'].length != count
    			url = "https://api.edamam.com/search?q=chicken&app_id="+ENV['EDAMAM_APP_ID']+"&app_key="+ENV['EDAMAM_APP_KEY']+"&from=0&to=3&calories=gte%20591,%20lte%20722&health=alcohol-free"
    			h = HTTParty.get(url)
    			text = h['hits'].each do |hit| 
    				text = hit['recipe']['url']
    				bot.api.send_message(chat_id: message.chat.id, text: text)
    			end
    			break
    		end
    	end
    end
  end	
  end
end

