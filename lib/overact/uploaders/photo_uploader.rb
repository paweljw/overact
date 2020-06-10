class PhotoUploader < Shrine
  Attacher.derivatives do |original|
    magick = ImageProcessing::MiniMagick.source(original)

    {
      thumbnai:  magick.resize!('150x150'),
    }
  end
end
