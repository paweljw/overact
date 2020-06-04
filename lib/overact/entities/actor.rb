require_relative '../uploaders/photo_uploader'

class Actor < Hanami::Entity
  # TODO: Not the entity's responsibility
  def photo
    PhotoUploader::UploadedFile.new(photo_data) if photo_data
  end
end
