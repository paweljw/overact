module Web
  class ActorPresenter
    include Hanami::Presenter

    def photo
      PhotoUploader::UploadedFile.new(photo_data) if photo_data
    end

    def image_url_with_fallback
      photo_url = photo&.url

      return _raw(photo_url) if photo_url
      # ugly hack due to double-escaping somewhere
      return _raw(image_url.gsub('&#x2F;', '/')) if image_url
      _raw('https://via.placeholder.com/150')
    end

    def imdb_url
      _raw "https://imdb.com/name/#{tt_id}"
    end
  end
end
