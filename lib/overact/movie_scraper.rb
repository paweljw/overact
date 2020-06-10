# frozen_string_literal: true

require 'open-uri'
require 'ostruct'

class MovieScraper
  # TODO: whisk this very far away
  # rubocop:disable Metrics/AbcSize
  def self.wrap_actor(element)
    first_link = element.css('a')[1]

    nm_id = first_link.attr('href').split('/')[2]
    role_name = element.css('td')[3].text.split("\n")[1].strip[1..-1]
    image_url = element.css('img').first&.attr('loadlate') &.gsub(/@@(.*)\.jpg/, '@@.jpg')&.gsub(/\._(.*)\.jpg/, '.jpg')

    OpenStruct.new(
      name: first_link.text.strip,
      tt_id: nm_id,
      character_name: role_name,
      image_url: image_url
    )
  end
  # rubocop:enable Metrics/AbcSize

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
    # rubocop:disable Security/Open
    @doc ||= Nokogiri::HTML(open(@url, 'Accept-Language' => 'en-US,en;q=0.5'))
    # rubocop:enable Security/Open
  end

  def table
    @table ||= doc.css('.cast_list tr')
  end
end
