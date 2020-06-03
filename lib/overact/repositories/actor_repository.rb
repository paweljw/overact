class ActorRepository < Hanami::Repository
  associations do
    has_many :roles
  end

  def find_by_tt(tt_id:)
    actors.where(tt_id: tt_id).first
  end
end
