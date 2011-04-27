def sleepyPD(ticketID)
   require 'rubygems'
   require 'nokogiri'
   require 'rest-client'
   nonascii = /[\x80-\xff]/ 

   # scrape some
   response = RestClient.post 'http://cjis.lincoln.ne.gov/HTBIN/ACC.COM', :tick => ticketID
   doc = Nokogiri::HTML(response.to_str)
   resp = doc.xpath('//table//tr[td[@style]]')
   i=0
   respclean = Array.new
   resp.each do |row|
     respclean[i] = row.to_s.gsub(/<.*?>/, "").gsub(nonascii, "").gsub("\n",",") #.each do |row|
     i = i + 1
   end
   jsonObj = '{'
   
   jsonObj += '"ticketNum":"'+respclean[0].split(',').at(1).gsub(" ",'')+'",'
   jsonObj += '"offenseDate":"'+respclean[0].split(',').at(2).gsub(" ",'')+'",'
   jsonObj += '"docketNum":"'+respclean[0].split(',').at(3).gsub(" ",'')+'",'
  # puts jsonObj
   jsonObj += '"charges":['
   # each
   respSize = respclean.size-5
   k=0
   while k < respSize
      if k>2
         jsonObj += ','
      end
      jsonObj += '{"citedFor":"'+respclean[k+1].split(',').at(4).gsub("  ",'').strip+'",'
      jsonObj += '"chargedWith":"'+respclean[k+2].split(',').at(3).gsub("  ",'').strip+'",'
      jsonObj += '"amendedTo":"'+respclean[k+3].split(',').at(3).gsub("  ",'').strip+'",'
      jsonObj += '"disposition":"'+respclean[k+4].gsub("DISPOSITION: ",'').gsub("  ",'').strip+'"}'
      k = k+5
   end
   jsonObj += ']}'
   return jsonObj
end