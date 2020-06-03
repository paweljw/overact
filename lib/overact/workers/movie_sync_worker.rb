require 'open-uri'
require 'pry'

class MovieSyncWorker
  include Sidekiq::Worker

  def perform(tt_id)
    movie_repo = MovieRepository.new
    movie = movie_repo.find_by_tt(tt_id: tt_id)

    return if movie&.checked? # we've probably fired this off twice or something

    constructed_url = "https://www.imdb.com/title/#{tt_id}/fullcredits"
    doc = Nokogiri::HTML(open(constructed_url, 'Accept-Language' => 'en-US,en;q=0.5'))
    # binding.pry
    table = doc.css('.cast_list tr')
    movie_name = doc.at_css('h3 a').text.strip

    unless movie
      movie_object = Movie.new(name: movie_name, tt_id: tt_id, status: Movie::CHECKING)
      movie = movie_repo.create(movie_object)
    end

    actor_repo = ActorRepository.new
    role_repo = RoleRepository.new

    table.each do |el|
      next if el.css('td').count < 2
      first_link = el.css('a')[1]

      actor_name = first_link.text.strip
      nm_id = first_link.attr('href').split('/')[2]
      role_name = el.css('td')[3].text.split("\n")[1].strip[1..-1]

      actor = actor_repo.find_by_tt(tt_id: nm_id)

      image_url = el.css('img').first&.attr('loadlate') &.gsub(/@@(.*)\.jpg/, '@@.jpg')&.gsub(/\._(.*)\.jpg/, '.jpg')

      unless actor
        actor = actor_repo.create({ name: actor_name, tt_id: nm_id, image_url: image_url })
        PhotoDownloadWorker.perform_async(actor.id)
      end

      role = role_repo.find_by_movie_and_actor(movie_id: movie.id, actor_id: actor.id)

      unless role
        role_object = Role.new(movie_id: movie.id, actor_id: actor.id, character_name: role_name || 'Unavailable')
        role = role_repo.create(role_object)
      end
    end

    movie_repo.update(movie.id, Movie.new(name: movie_name, status: Movie::CHECKED))
    puts movie.id
    nil
  end
end
