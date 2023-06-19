# frozen_string_literal: true

require 'mechanize'
require 'uri'
require 'json'
require 'rspec'
require 'vcr'

require_relative '../../lib/helpers/url_builder'
require_relative '../../lib/services/crawler'

VCR.configure do |config|
  config.cassette_library_dir = 'spec/fixtures/vcr_cassettes'
  config.hook_into :webmock
end

describe Crawler do
  let(:crawler) { described_class.new }
  let(:url_static) { 'https://static2.meucarronovo.com.br/imagens-dinamicas/lista/fotos/' }

  let(:url_api) { 'https://www.meucarronovo.com.br/api/v2/busca' }
  let(:options) do
    {
      limite: 10,
      pagina: 1,
      tipoVeiculo: 'A',
      cidade: 'Curitiba'
    }
  end

  describe '#fetch_json' do
    it 'returns parsed JSON response' do
      VCR.use_cassette('meu_carro_novo_api_fetch_options_json') do
        json_data = crawler.fetch_json(url_api, options)

        expect(json_data['paginaCorrente']).to eq(1)
        expect(json_data['ultimaPagina']).to eq(738)
      end
    end
  end

  describe '#fetch_image' do
    let(:route) { 'r/17031/v/22475671/EpuoZ2rxE4W.jpg' }

    it 'returns the image data' do
      VCR.use_cassette('meu_carro_novo_static_fetch_image') do
        image_data = crawler.fetch_image(url_static, route)

        expect(image_data).not_to be_empty
      end
    end
  end
end
