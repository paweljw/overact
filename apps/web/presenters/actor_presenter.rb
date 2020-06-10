# frozen_string_literal: true

module Web
  class ActorPresenter
    include Hanami::Presenter

    def image_url_with_fallback(image)
      photo_url = image&.url

      return _raw(photo_url) if photo_url
      # ugly hack due to double-escaping somewhere
      return _raw(image_url.gsub('&#x2F;', '/')) if image_url

      _raw('https://via.placeholder.com/150')
    end

    def photo
      PhotoUploader::UploadedFile.new(photo_data) if photo_data
    end

    def thumbnail
      PhotoUploader::UploadedFile.new(photo_data.dig(:derivatives, :thumbnail)) if photo_data
    end

    def photo_url
      image_url_with_fallback(photo)
    end

    def thumbnail_url
      image_url_with_fallback(thumbnail)
    end

    def imdb_url
      _raw "https://imdb.com/name/#{tt_id}"
    end
  end
end
