# frozen_string_literal: true

require 'uri'

class URLBuilder
  def initialize(url, options = nil)
    @url = url
    @options = options
  end

  def build_url
    return @url if @options.nil? || @options.empty?

    uri = URI(@url)
    uri.query = URI.encode_www_form(query_params)
    uri.to_s
  end

  private

  def query_params
    @options.to_h { |key, value| [key.to_s, value.to_s] }
  end
end
