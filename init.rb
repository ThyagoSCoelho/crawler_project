# frozen_string_literal: true

require_relative 'lib/my_new_car_crawler'

require 'pry'

def options_params(limit, page, type, city)
  {
    limite: limit,
    pagina: page,
    tipoVeiculo: type,
    cidade: city
  }
end

def search_scope(options)
  my_new_car_crawler = MyNewCarCrawler.new
  pagination = my_new_car_crawler.call(options)

  return if pagination == 'No results found'
  return if pagination[:current_page] == pagination[:final_page]

  options[:pagina] = pagination[:current_page] + 1

  search_scope(options)
end

search_scope(options_params(20, 1, 'A', 'Francisco Beltrão'))

# Francisco Beltrão
# pesquisa de 10 a cada 1 pagina de 6 paginas no total - A diferença em segundos entre as datas é: 6831ms
# pesquisa de 20 a cada 1 pagina de 6 paginas no total - A diferença em segundos entre as datas é: 5539ms
# pesquisa de 30 a cada 1 pagina de 6 paginas no total - A diferença em segundos entre as datas é: 7259ms

# Curitiba
# pesquisa de 100 a cada 1 pagina de 738 paginas no total - A diferença em segundos entre as datas é: 9.5386m
