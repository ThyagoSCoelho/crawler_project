# frozen_string_literal: true

require 'json'

require_relative 'spec_helper'
require_relative '../lib/data_logger'

RSpec.describe DataLogger do
  let(:documents) do
    [
      {
        'fotoCapa' => 'pVtvgVN3zaa.jpg',
        'modeloNome' => 'Modelo 1',
        'marcaNome' => 'Marca 1',
        'preco' => 10_000,
        'anoFabricacao' => 2020,
        'anoModelo' => 2021
      },
      {
        'fotoCapa' => '',
        'modeloNome' => 'Modelo 2',
        'marcaNome' => 'Marca 2',
        'preco' => 20_000,
        'anoFabricacao' => 2019,
        'anoModelo' => 2020
      }
    ]
  end

  let(:options) { { cidade: 'SaoPaulo', pagina: 1 } }

  let(:data_logger) { described_class.new(documents, options) }

  describe '#save_data' do
    let(:data) do
      [
        {
          modelo: 'Modelo 1',
          marca: 'Marca 1',
          valor: 10_000,
          ano_fabricacao: 2020,
          ano_modelo: 2021,
          image: 'data/images/pVtvgVN3zaa.jpg'
        },
        {
          modelo: 'Modelo 2',
          marca: 'Marca 2',
          valor: 20_000,
          ano_fabricacao: 2019,
          ano_modelo: 2020,
          image: 'no_image'
        }
      ]
    end

    let(:file_path) { 'spec/data/SaoPaulo_page_1_*.json' }

    it 'writes the data to a file with correct content' do
      data_logger.send(:save_data, data)

      file_content = File.read(Dir[file_path].first)
      expected_content = data.to_json

      expect(file_content).to eq(expected_content)
    end
  end
end
