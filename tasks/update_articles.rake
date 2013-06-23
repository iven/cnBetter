require 'open-uri'
require 'nokogiri'

def format_paragraph(doc)
  doc.css('br').each do |node|
    node.remove
  end
  doc.xpath('//p/text() | //b/text()').each do |node|
    node.content = node.content.gsub('　', '')
  end
end

def self.format_video(doc)
  doc.css('embed').wrap '<div align="center"></div>'
end

def self.format_image(doc)
  doc.css('img').wrap '<div align="center"></div>'
end

def update_article(id)
    uri = "http://m.cnbeta.com/view.htm?id=#{id}"

    doc = Nokogiri::HTML(open(uri).read.force_encoding('utf-8'))

    format_image(doc)
    format_video(doc)
    format_paragraph(doc)

    title = doc.css('div.title b')[0].text
    content = doc.css('div.content')[0]

    Article.create(
      id: id,
      title: title,
      content: content,
    )
end

task update_articles: :environment do
  doc = Nokogiri::HTML(open('http://m.cnbeta.com/'))

  doc.css('div.list a').each do |a|
    id = a['href'].split('=')[1]
    unless Article.get(id)
      update_article(id)
    end
  end
end
