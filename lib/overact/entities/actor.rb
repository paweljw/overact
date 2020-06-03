require_relative '../uploaders/photo_uploader'

class Actor < Hanami::Entity
  def photo
    PhotoUploader::UploadedFile.new(photo_data) if photo_data
  end
end
