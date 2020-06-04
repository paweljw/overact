module Web
  class ActorPresenter
    include Hanami::Presenter

    def photo
      PhotoUploader::UploadedFile.new(photo_data) if photo_data
    end

    def image_url_with_fallback
      _raw photo&.url || image_url || 'https://via.placeholder.com/150'
    end

    def imdb_url
      _raw "https://imdb.com/name/#{tt_id}"
    end
  end
end
