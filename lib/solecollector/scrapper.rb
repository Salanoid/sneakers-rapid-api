module Solecollector
	class Scrapper
		def self.run!(month: nil, all_releases: false)
			solecollector_sneakers_info_arr = Array.new
			endpoints(month, all_releases).each do |endpoint|
				solecollector_sneakers_info_arr << sneakers_info(endpoint)
			end
      solecollector_sneakers_info_arr.flatten.compact.uniq
		end

    def self.sneakers_info(endpoint)
      unparsed_page = HTTParty.get(endpoint)
      return [] if unparsed_page.body.nil? || unparsed_page.body.empty?.present?
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
        end.flatten.compact.uniq
    end
		
		def self.endpoints(month, all_releases)
      month = month.to_s.size == 1 ? "0#{month}" : month

			if month.present?
				["https://solecollector.com/sneaker-release-dates/all-release-dates/#{Date.current.year}/#{month}"]
			elsif all_releases
				all_releases_endpoints
			else
				['https://solecollector.com/sneaker-release-dates/all-release-dates/']
			end

		end

    def self.all_releases_endpoints
      current_month = Date.current.month.to_s.size == 1 ? "0#{Date.current.month}" : Date.current.month
      next_month = (Date.current.month + 1).to_s.size == 1 ? "0#{Date.current.month + 1}" : Date.current.month + 1
      next_second_month = (Date.current.month + 2).to_s.size == 1 ? "0#{Date.current.month + 2}" : Date.current.month + 2

      if Date.current.month == 12
        [
          "https://solecollector.com/sneaker-release-dates/all-release-dates/#{Date.current.year}/#{current_month}",
          "https://solecollector.com/sneaker-release-dates/all-release-dates/#{Date.current.year + 1}/01",
          "https://solecollector.com/sneaker-release-dates/all-release-dates/#{Date.current.year + 1}/02"
        ]
      elsif Date.current.month == 11
        [
          "https://solecollector.com/sneaker-release-dates/all-release-dates/#{Date.current.year}/#{current_month}",
          "https://solecollector.com/sneaker-release-dates/all-release-dates/#{Date.current.year}/#{next_month}",
          "https://solecollector.com/sneaker-release-dates/all-release-dates/#{Date.current.year + 1}/01"
        ]
      else
        [
          "https://solecollector.com/sneaker-release-dates/all-release-dates/#{Date.current.year}/#{current_month}",
          "https://solecollector.com/sneaker-release-dates/all-release-dates/#{Date.current.year}/#{next_month}",
          "https://solecollector.com/sneaker-release-dates/all-release-dates/#{Date.current.year}/#{next_second_month}"
        ]
      end
    end
	end
end