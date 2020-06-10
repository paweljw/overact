# frozen_string_literal: true

class RoleUpserter
  include Hanami::Interactor

  expose :role

  def initialize(role_repo: RoleRepository.new)
    @role_repo = role_repo
  end

  def call(attributes)
    movie_id = attributes[:movie_id]
    actor_id = attributes[:actor_id]

    @role = @role_repo.find_by_movie_and_actor(movie_id: movie_id, actor_id: actor_id)

    return if @role

    @role = @role_repo.create(attributes)
  end
end
