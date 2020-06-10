# frozen_string_literal: true

class ScrapedPairUpserter
  include Hanami::Interactor

  def initialize(actor_upserter: ActorUpserter.new, role_upserter: RoleUpserter.new)
    @actor_upserter = actor_upserter
    @role_upserter = role_upserter
  end

  def call(movie_id:, scraped_pair:)
    actor = @actor_upserter.call({
                                   name: scraped_pair.name,
                                   tt_id: scraped_pair.tt_id,
                                   image_url: scraped_pair.image_url
                                 }).actor

    @role_upserter.call({
                          movie_id: movie_id,
                          actor_id: actor.id,
                          character_name: scraped_pair.character_name || 'Unavailable'
                        })
  end
end
