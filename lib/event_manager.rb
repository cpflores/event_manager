require 'csv'
require 'sunlight/congress'
require 'erb'

meaning_of_life = 42

question = "The Answer to the Ultimate Question of Life, the Universe, and Everything is <%= meaning_of_life %>"
template = ERB.new question

results = template.result(binding)
puts results

Sunlight::Congress.api_key = "e179a6973728c4dd3fb1204283aaccb5"

def clean_zipcode(zipcode)
	zipcode.to_s.rjust(5,"0")[0..4]
end 

def legislators_by_zipcode(zipcode)
	legislators = Sunlight::Congress::Legislator.by_zipcode(zipcode)

	legislator_names = legislators.collect do |legislator|
  	"#{legislator.first_name} #{legislator.last_name}"
	end

	legislator_names.join(", ")	
end

puts "EventManager initialized."

contents = CSV.open "event_attendees.csv", headers: true, header_converters: :symbol

template_letter = File.read "form_letter.html"

contents.each do |row|
	name = row[:first_name]
	zipcode = clean_zipcode(row[:zipcode])
	legislators = legislators_by_zipcode(zipcode)
  
  personal_letter = template_letter.gsub('FIRST_NAME',name)
  personal_letter.gsub!('LEGISLATORS',legislators)

  puts personal_letter
end