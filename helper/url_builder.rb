require 'uri'

class URLBuilder
  def initialize(url, options)
    @url = url
    @options = options
  end

  def build_url
    uri = URI(@url)
    uri.query = URI.encode_www_form(query_params)
    uri.to_s
  end

  private

  def query_params
    @options.map { |key, value| [key.to_s, value.to_s] }.to_h
  end
end