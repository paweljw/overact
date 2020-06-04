class ActorUpserter
  include Hanami::Interactor

  expose :actor

  def initialize(actor_repo: ActorRepository.new, worker: PhotoDownloadWorker)
    @actor_repo = actor_repo
    @worker = worker
  end

  def call(attributes)
    tt_id = attributes[:tt_id]

    @actor = @actor_repo.find_by_tt(tt_id: tt_id)

    return if @actor

    @actor = @actor_repo.create(attributes)
    @worker.perform_async(@actor.id)
  end
end
