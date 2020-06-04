module Web
  class ActorPresenter
    include Hanami::Presenter

    def photo
      PhotoUploader::UploadedFile.new(photo_data) if photo_data
    end
  end
end
