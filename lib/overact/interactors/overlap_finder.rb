# frozen_string_literal: true

class OverlapFinder
  include Hanami::Interactor

  expose :overlap

  def initialize(role_repo: RoleRepository.new, actor_repo: ActorRepository.new)
    @role_repo = role_repo
    @actor_repo = actor_repo
  end

  # NOTE: This is still hard to test, valid place to start second pass of refactor
  def call(movie1_id:, movie2_id:)
    overlapping_actors = @role_repo.find_by_movie_overlap(movie1_id: movie1_id, movie2_id: movie2_id)

    @overlap = overlapping_actors.map do |role|
      actor_id = role[:actor_id]
      [
        @actor_repo.find(actor_id),
        @role_repo.find_by_movie_and_actor(movie_id: movie1_id, actor_id: actor_id),
        Role.new(role)
      ]
    end
  end
end
