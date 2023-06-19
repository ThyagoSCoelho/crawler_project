# frozen_string_literal: true

require_relative 'services/crawler'
require_relative 'data_logger'
require 'pry'

MEU_CARRO_NOVO_API = 'https://www.meucarronovo.com.br/api/v2/busca'

class MyNewCarCrawler
  def initialize
    @crawler = Crawler.new
  end

  def call(options)
    @options_search = options
    search
  end

  private

  def search
    @json_data = @crawler.fetch_json(MEU_CARRO_NOVO_API, @options_search)
    documents = @json_data['documentos']

    return 'No results found' if documents.empty?

    save(documents, @options_search)
    pagination
  end

  def pagination
    {
      current_page: @json_data['paginaCorrente'],
      final_page: @json_data['ultimaPagina']
    }
  end

  def save(documents, options)
    logger = DataLogger.new(documents, options)
    logger.save
  end
end
