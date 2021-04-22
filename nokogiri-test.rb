require "nokogiri"
require "open-uri"
require 'csv'

url = "https://izakaya-wagaya-akihabara.com/category/100%e5%86%86%e3%83%a1%e3%83%8b%e3%83%a5%e3%83%bc/"

charset = nil



html = open(url) do |f|
    charset = f.charset
    f.read
end

doc = Nokogiri::HTML.parse(html, nil, charset)
doc.xpath('//div[@class="list ect-entry-card front-page-type-index"]').each do |node|
  a = node.css('a')[0]
  next unless a
  title = a.text
  link = a['href']
  puts link

  html = open(link) do |f|
    charset = f.charset
    f.read
  end
  doc = Nokogiri::HTML.parse(html, nil, charset)
  doc.xpath('//div[@class="entry-content cf"]').each do |node|
    a = node.css('div').inner_text
    list = a.gsub!(/《.*》|◆.*。|※.*。|◎.*…/, '').split(/\n|\(.\)/).reject(&:empty?)
    hyakuyen = Hash[*list]
    p hyakuyen
    header = ["日", "メニュー"]
    CSV.open('100yen.csv','w') do |csv|
      csv << header
      hyakuyen.each do |d|
        csv << d
      end
    end
  end
end
