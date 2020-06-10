# frozen_string_literal: true

class MovieSyncWorker
  include Sidekiq::Worker

  sidekiq_options retry: 3, queue: 'critical'

  def perform(tt_id, movie_repo: MovieRepository.new, movie_scraper: MovieScraper, pair_upserter: ScrapedPairUpserter.new)
    movie = movie_repo.find_by_tt(tt_id: tt_id)
    return if !movie || movie&.checked?

    scraped = movie_scraper.new(tt_id: tt_id)
    scraped.actors.each { |scraped_pair| pair_upserter.call(movie_id: movie.id, scraped_pair: scraped_pair) }
    movie_repo.update(movie.id, { name: scraped.movie_name, status: Movie::CHECKED })
  end
end
