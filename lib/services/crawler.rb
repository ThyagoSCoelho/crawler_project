# frozen_string_literal: true

require_relative '../helpers/url_builder'

require 'mechanize'
require 'json'

class Crawler
  def initialize
    @agent = Mechanize.new
  end

  def fetch_json(url, options = {})
    response = @agent.get(build_url(url, options))
    JSON.parse(response.body)
  end

  def fetch_image(url, route)
    response = @agent.get(url + route)
    return 'No image found' if response.code == '404'

    response.body
  end

  private

  def build_url(url, options)
    url_builder = URLBuilder.new(url, options)
    url_builder.build_url
  end
end
