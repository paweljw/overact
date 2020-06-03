class PhotoDownloadWorker
  include Sidekiq::Worker

  def perform(actor_id)
    actor_repo = ActorRepository.new
    actor = actor_repo.find(actor_id)

    return unless actor.image_url
    return if actor.photo

    photo_attacher = PhotoUploader::Attacher.new
    photo_attacher.assign_remote_url(actor.image_url)
    photo_attacher.promote

    actor_repo.update(actor_id, photo_data: photo_attacher.data)
  end
end
