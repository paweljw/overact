class PhotoDownloadWorker
  include Sidekiq::Worker

  def perform(actor_id, interactor: PromoteActorPhoto.new)
    interactor.call(actor_id: actor_id)
  end
end
