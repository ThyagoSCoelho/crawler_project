# frozen_string_literal: true

require 'mechanize'
require 'uri'
require 'json'
require 'rspec'
require 'vcr'

require_relative 'spec_helper'
require_relative '../lib/my_new_car_crawler'
require_relative '../lib/helpers/url_builder'
require_relative '../lib/services/crawler'

VCR.configure do |config|
  config.cassette_library_dir = 'spec/fixtures/vcr_cassettes'
  config.hook_into :webmock
end

RSpec.describe MyNewCarCrawler do
  subject(:crawler_instance) { described_class.new }

  let(:options) do
    {
      limite: 10,
      pagina: 1,
      tipoVeiculo: 'A',
      cidade: 'Curitiba'
    }
  end

  describe '#call' do
    context 'when results are found' do
      it 'fetches JSON data, saves it, and returns pagination information' do
        VCR.use_cassette('my_new_car_crawler_results_found') do
          result = crawler_instance.call(options)

          expect(result).to eq({ current_page: 1, final_page: 738 })
        end
      end
    end

    context 'when no results are found' do
      it 'returns "No results found"' do
        VCR.use_cassette('my_new_car_crawler_no_results_found') do
          options[:pagina] = 800
          result = crawler_instance.call(options)

          expect(result).to eq('No results found')
        end
      end
    end
  end
end
