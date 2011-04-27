require 'rubygems'
require 'date'
require 'nokogiri'
require 'rest-client'

startDate = Date::civil(2000, 1, 1) # When LPD started making data available
endDate   = Date.today              # The current system date

aFile = File.new("lpd.csv", "w+")

while startDate <= endDate
   # scrape some
   target = startDate.month.to_s + "-" + startDate.day.to_s + "-" + startDate.year.to_s # is there a strfdate?
   puts 'Fetching: ' + target
   response = RestClient.post 'http://cjis.lincoln.ne.gov/HTBIN/ACC.COM', :date => target, :rky => ''
   doc = Nokogiri::HTML(response.to_str)

   doc.xpath('//table[1]//tr').each do |row|
      tempStr=""
      row.xpath('td').each do |cell|
         tempStr += '"' + cell.text.gsub("\n", '').gsub('"', '\"').gsub(/(\s){2,}/m, '').gsub('Â','').gsub('  ','').strip + "\","
      end
      tempStr += "\n"
      if tempStr.include? '-'
        unless tempStr.include? 'View the accident report by \"clicking\" on the BLUE case number at the left of the line.' 
           aFile.syswrite(tempStr)
        end
      end
   end
   startDate = startDate + 1  # my inner C programmer just died a little
end