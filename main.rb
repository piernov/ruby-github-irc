require 'eventmachine'
require 'thin'
require 'yaml'

require './webapp'
require './ircbot'

config = YAML::load_file('config.yml')

ircbot = IRCBot.new do
	configure do |c|
		c.nick		= config["ircbot"]["nick"]
		c.server	= config["ircbot"]["server"]
		c.port		= config["ircbot"]["port"]
		@chan		= config["ircbot"]["channel"]
	end
end

webapp = WebApp.new
webapp.settings.set "bot", ircbot

EM.defer do
	dispatch = Rack::Builder.app do
		map '/' do
			run webapp
		end
	end

	Rack::Server.start({
		app:		dispatch,
		server:		'thin',
		Host:		config["webapp"]["host"],
		Port:		config["webapp"]["port"],
		signals: false,
	})
end
EM.defer ircbot.start
