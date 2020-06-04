class RoleRepository < Hanami::Repository
  associations do
    belongs_to :actor
    belongs_to :movie
  end

  def find_by_movie_and_actor(movie_id:, actor_id:)
    roles.where(movie_id: movie_id, actor_id: actor_id).first
  end

  # TODO: for the love of all that is holy unmess this up
  def find_by_movie_overlap(movie1_id:, movie2_id:)
    movie1_roles = roles.where(movie_id: movie1_id)
    aggregate(:actor).where(movie_id: movie2_id, actor_id: movie1_roles.map { |e| e[:actor_id] })
  end
end
