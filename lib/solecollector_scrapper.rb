module SolecollectorScrapper
  def self.run!
  	endpoint = 'https://solecollector.com/sneaker-release-dates/all-release-dates/'
		unparsed_page = HTTParty.get(endpoint)
		parsed_page = Nokogiri::HTML(unparsed_page)  
	
		solecollector_sneakers_info_arr = 
			parsed_page.css('div.sneaker-release-item').each_with_object([]) do |release, acc|
				date_as_string = release.css('.add-to-calendar').attr('data-date').value.split(' ').first

				acc << 
					{
						name: release.css('div.add-to-calendar').attr('data-release-name').value,
						price: release.css('.sneaker-release__options').text.strip,
						date: (Date.strptime(date_as_string, '%m/%d/%Y') + 2000.years).to_date,
						image: release.css('img').attr('src').value,
					}
			end
  end					
end