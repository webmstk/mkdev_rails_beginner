require 'open-uri'

doc = Nokogiri::HTML(open 'http://www.study.ru/support/phrasebook/everyday.html')

tables = doc.css('.mainbody .tableblue')

tables[1].css('tr').each do |tr|
  td = tr.css('td')
  Card.create(original_text: td[0].text, translated_text: td[1].text)
end