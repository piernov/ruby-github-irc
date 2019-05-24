require "sinatra/base"
require "sinatra/github"
require 'slim'
require 'pp'
require 'json'

class WebApp < Sinatra::Base
	configure do
		register Sinatra::Github
		set :threaded, false
	end

	def sendMsg msg
		settings.bot.msg msg
p msg
	end

	get "/" do
		"Miaou"
	end

	post "/webhook" do
		payload = JSON.parse(request.body.read.to_s)

		case payload["object_kind"]
		when "push"
			if payload["commits"].length > 1 then
				sendMsg "#{payload["commits"].length} commits pushed onto #{payload["ref"]}"
				i = 0
				payload["commits"].each do |c|
					sendMsg "#{c["author"]["name"]}: #{c["message"]}"
					i = i + 1
					if i > 3 then return end
				end
			else
				c = payload["commits"][0]
				sendMsg "[#{payload["ref"]}] #{c["author"]["name"]}: #{c["message"]}"
			end
#		when "merge_request"
#			sendMsg "#{payload["pull_request"]["user"]["name"]} #{payload["action"]} PR ##{payload["number"]} #{payload["pull_request"]["title"]}"
		when "build"
			pp payload["build_status"]
			if payload["build_status"] == "success" or payload["build_status"] == "failed" then
				sendMsg "[#{payload["ref"]}] Build #{payload["build_id"]}: #{payload["build_status"]} in #{payload["build_duration"]} seconds"
			end
		else
#			pp payload
		end
	end
end
