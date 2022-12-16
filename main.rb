require 'open-uri'
require 'nokogiri'
require 'byebug'
require 'json'
require 'csv'

url = 'https://rozetka.com.ua/fitnes-trekery/c4627554/vlagozashchita-215513=bez-vlagozashchiti/'
html = open(url) { |result| result.read }

document = Nokogiri::HTML(html)
content = document.css('li.catalog-grid__cell')

goods = 
	document.css('li.catalog-grid__cell').map do |position|
		byebug
		{
			code: position.css('div.g-id').text,
			name: position.css('.goods-tile__heading.ng-star-inserted').text,
			price: position.css('.goods-tile__price').text
		}
end

File.open("output.json","w") do |f|
  f.write(goods.to_json)
end

csv_string = CSV.generate do |csv|
  JSON.parse(goods.to_json).each do |hash|
    csv << hash.values
  end
end


File.open("output.csv","w") do |f|
  f.write(csv_string)
end
