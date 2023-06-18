require_relative '../helper/url_builder'

require 'mechanize'
require 'json'

class Crawler
	def initialize
		@agent = Mechanize.new
	end

	def fetch_json(url, options = {})
		response = @agent.get(build_url(url, options))
		json = JSON.parse(response.body)
		return json
	end

	def fetch_image(url, route)
		response = @agent.get(url + route)
		return response.body
	end

	private

	def build_url(url, options)
		url_builder = URLBuilder.new(url, options)
		url_builder.build_url
	end
end
