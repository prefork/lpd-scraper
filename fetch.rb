require 'rubygems'
require 'fastercsv'
require 'ticket'
doc = FasterCSV.read("lpd.csv")
aFile = File.new("master.json", "w+")
lFile = File.new("master.log", "w+")
aFile.syswrite('[')
doc.each{|row|
  unless(row.at(4).strip == "NONE")
     lFile.syswrite("Fetching: "+row.at(0).strip+"\n")
     begin
       temp = sleepyPD(row.at(0).strip)
       unless row == doc.last
         temp += ","
       end
       aFile.syswrite(temp)
     rescue
       lFile.syswrite(puts "Failed on: "+row.at(0).strip+"\n")
     end
  end
}
aFile.syswrite(']')