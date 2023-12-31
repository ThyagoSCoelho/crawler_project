# frozen_string_literal: true

MEU_CARRO_NOVO_STATIC = 'https://static2.meucarronovo.com.br/imagens-dinamicas/lista/fotos/'

class DataLogger
  def initialize(documents, options = nil)
    @documents = documents
    @options = options
  end

  def save
    save_data(data_structure)
  end

  private

  def data_structure
    @documents.map do |document|
      route_image = document['fotoCapa']
      {
        modelo: document['modeloNome'],
        marca: document['marcaNome'],
        valor: document['preco'],
        ano_fabricacao: document['anoFabricacao'],
        ano_modelo: document['anoModelo'],
        image: route_image.empty? ? 'no_image' : save_image(route_image)
      }
    end
  end

  def file_name
    date = Time.now
    "#{@options[:cidade]}_page_#{@options[:pagina]}_#{date.to_i}"
  end

  def save_data(data)
    destination_path = "data/#{file_name}.json"
    File.write(destination_path, data.to_json)
  end

  def save_image(route_path)
    image_data = image_search(route_path)
    return 'no_image' if image_data == 'No image found'

    destination_path = "data/images/#{route_path.split('/').last}"
    File.binwrite(destination_path, image_data)
    destination_path
  end

  def image_search(route_path)
    @crawler = Crawler.new
    @crawler.fetch_image(MEU_CARRO_NOVO_STATIC, route_path)
  end
end
