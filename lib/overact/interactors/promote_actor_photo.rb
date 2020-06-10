# frozen_string_literal: true

class PromoteActorPhoto
  def initialize(repo: ActorRepository.new, attacher: PhotoUploader::Attacher.new)
    @repo = repo
    @attacher = attacher
  end

  def call(actor_id:)
    actor = @repo.find(actor_id)

    return if !actor.image_url || actor.photo_data

    @attacher.assign_remote_url(actor.image_url)
    @attacher.create_derivatives
    @attacher.promote

    @repo.update(actor_id, photo_data: @attacher.data)
  end
end
