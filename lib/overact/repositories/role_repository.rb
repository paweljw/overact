class RoleRepository < Hanami::Repository
  associations do
    belongs_to :actor
    belongs_to :movie
  end

  def find_by_movie_and_actor(movie_id:, actor_id:)
    roles.where(movie_id: movie_id, actor_id: actor_id).first
  end

  def find_by_movie_overlap(movie1_id:, movie2_id:)
    movie1_roles = roles.where(movie_id: movie1_id)
    overlap = aggregate(:actor).where(movie_id: movie2_id, actor_id: movie1_roles.map { |e| e[:actor_id] }).map_to(Actor)
    overlap
  end
end
