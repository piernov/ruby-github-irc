require "sinatra/base"
require "sinatra/github"
require 'slim'

class WebApp < Sinatra::Base
	configure do
		register Sinatra::Github
		set :threaded, false
	end

	def sendMsg msg
		settings.bot.msg msg
	end

	get "/" do
		"Miaou"
	end

	github :ping, '/webhook' do
		sendMsg "WebHook Ping"
	end

	github :push, '/webhook' do
		if payload["commits"].length > 1 then
			sendMsg "#{payload["commits"].length} commits pushed onto #{payload["ref"]}"
			payload["commits"].each do |c|
				sendMsg "#{c["author"]["name"]}: #{c["message"]}"
			end
		else
			c = payload["commits"][0]
			sendMsg "[#{payload["ref"]}] #{c["author"]["name"]}: #{c["message"]}"
		end
	end

	github :pull_request, '/webhook' do
		sendMsg "#{payload["pull_request"]["user"]["login"]} #{payload["action"]} PR ##{payload["number"]} #{payload["pull_request"]["title"]}"
	end
end
