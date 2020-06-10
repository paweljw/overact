class PhotoDownloadWorker
  include Sidekiq::Worker

  sidekiq_options retry: 3, queue: 'low'

  def perform(actor_id, interactor: PromoteActorPhoto.new)
    interactor.call(actor_id: actor_id)
  end
end
