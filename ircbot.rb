require 'isaac/bot'

class IRCBot < Isaac::Bot
	def initialize &b
		super &b
		instance_eval do
			on :connect do
				join @chan
				puts "IRC: joined #{@chan}"
				msg "Miaou!"
			end

			on :channel, /miaou/i do
				msg "Nyan!"
			end
		end
	end

	def msg msg, chan = @chan
		super chan, msg
	end
end
