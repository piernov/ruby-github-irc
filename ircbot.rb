require 'isaac/bot'

class IRCBot < Isaac::Bot
	def initialize &b
		super &b
		instance_eval do
			on :connect do
				join @chan
				puts "IRC: joined #{@chan}"
				msg "Nyan!"
			end

			on :channel, /nyan/i do
				msg "Miaou!"
			end
		end
	end

	def msg msg, chan = @chan
		super chan, msg
	end
end
