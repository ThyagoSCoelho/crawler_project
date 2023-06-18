require_relative '../lib/crawler'
require 'pry'

MEU_CARRO_NOVO_API = 'https://www.meucarronovo.com.br/api/v2/busca'
MEU_CARRO_NOVO_STATIC = 'https://static2.meucarronovo.com.br/imagens-dinamicas/lista/fotos/'

class MyNewCarCrawler
  def initialize
    @crawler = Crawler.new
  end

  def call(limit, page, type, city)
    json_data = @crawler.fetch_json(MEU_CARRO_NOVO_API, options(limit, page, type, city))
    data = data_structure(json_data['documentos'])
    save_data(data)
  end

  private

  def data_structure(documents)  
    documents.map do |document|
      {
        modelo: document['modeloNome'],
        marca: document['marcaNome'],
        valor: document["preco"],
        ano_fabricacao: document["anoFabricacao"],
        ano_modelo: document["anoModelo"],
        image: save_image(document['fotoCapa'])
      }
    end
  end
  
  def save_image(route_path)
    image_data = @crawler.fetch_image(MEU_CARRO_NOVO_STATIC, route_path)
    destination_path = 'data/images/' + route_path.split('/').last
    File.open(destination_path, 'wb') do |file|
      file.write(image_data)
    end
    destination_path
  end
  
  def save_data(data)
    date = Time.now
    destination_path = "data/#{date.to_i}.json"
    File.open(destination_path, 'w') do |file|
      file.write(data.to_json)
    end
  end
  
  def options(limit, page, type, city)
    {
      limite: limit,
      pagina: page,
      tipoVeiculo: type,
      cidade: city
    }
  end
end


main = MyNewCarCrawler.new
main.call(10, 1, 'A', 'Curitiba')
