require 'open-uri'
require 'ostruct'

class MovieScraper
  def self.wrap_actor(el)
    first_link = el.css('a')[1]

    actor_name = first_link.text.strip
    nm_id = first_link.attr('href').split('/')[2]
    role_name = el.css('td')[3].text.split("\n")[1].strip[1..-1]
    image_url = el.css('img').first&.attr('loadlate') &.gsub(/@@(.*)\.jpg/, '@@.jpg')&.gsub(/\._(.*)\.jpg/, '.jpg')

    OpenStruct.new(
      name: actor_name,
      tt_id: nm_id,
      character_name: role_name,
      image_url: image_url
    )
  end

  def initialize(tt_id:, nokogiri: Nokogiri::HTML)
    @url = "https://www.imdb.com/title/#{tt_id}/fullcredits"
    @nokogiri = nokogiri
  end

  def movie_name
    @movie_name || doc.at_css('h3 a').text.strip
  end

  def actors
    @actors ||= table.map do |el|
      next if el.css('td').count < 2

      self.class.wrap_actor(el)
    end.reject(&:nil?)
  end

  private

  def doc
    @doc ||= Nokogiri::HTML(open(@url, 'Accept-Language' => 'en-US,en;q=0.5'))
  end

  def table
    @table ||= doc.css('.cast_list tr')
  end
end
