# frozen_string_literal: true

require 'uri'
require 'rspec'

require_relative '../../lib/helpers/url_builder'

describe URLBuilder do
  let(:url) { 'https://www.meucarronovo.com.br/api/v2/busca' }
  let(:options) do
    {
      limite: 10,
      pagina: 1,
      tipoVeiculo: 'A',
      cidade: 'Curitiba'
    }
  end

  describe '#build_url' do
    it 'returns the built URL with encoded query parameters' do
      url_builder = described_class.new(url, options)

      expected_query = 'limite=10&pagina=1&tipoVeiculo=A&cidade=Curitiba'
      expected_url = "#{url}?#{expected_query}"

      built_url = url_builder.build_url

      expect(built_url).to eq(expected_url)
    end

    it 'returns the built URL with encoded no options' do
      url_builder = described_class.new(url)

      expected_url = url

      built_url = url_builder.build_url

      expect(built_url).to eq(expected_url)
    end
  end
end
