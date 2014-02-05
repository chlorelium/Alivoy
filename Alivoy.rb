require 'open-uri'
require 'nokogiri'
#require 'rubyzip'
require 'odf-report'

puts "Alivoy 0.1 BETA"

print "Name:"
name = gets.chomp()

print "Street Number:"
streetnum = gets.chomp()

print "City:"
city = gets.chomp()

print "Province:"
province = gets.chomp()

print "Postal Code:"
postalcode = gets.chomp()

puts "\n\n"

puts "Your address is:\n#{name}\n#{streetnum}\n#{city},#{province}\n#{postalcode}"

page = Nokogiri::HTML(open("http://parl.gc.ca/ParlInfo/Compilations/HouseOfCommons/MemberByPostalCode.aspx?PostalCode=#{postalcode}"), nil, "UTF-8")

#puts page

mpname = page.css('a#ctl00_cphContent_repMP_ctl00_lnkPerson').text

mpname = mpname.split(", ").reverse.join(" ")

riding = page.css('span#ctl00_cphContent_repMP_ctl00_lblYellowBar').text

party = page.css('a#ctl00_cphContent_repMP_ctl00_lnkParty').text

puts "\n\n"

puts "Your Member of Parliament is #{mpname} (#{party}) in the #{riding} riding."

report = ODFReport::Report.new("./testdoc1.odt") do |r|
	r.add_field :name, name
	r.add_field :streetnum, streetnum
	r.add_field :city, city
	r.add_field :province, province
	r.add_field :postalcode, postalcode
	r.add_field :mpname, mpname

end

report.generate("./Reports/output.odf")
