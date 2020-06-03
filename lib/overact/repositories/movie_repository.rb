class MovieRepository < Hanami::Repository
  def find_by_tt(tt_id:)
    movies.where(tt_id: tt_id).first
  end
end
