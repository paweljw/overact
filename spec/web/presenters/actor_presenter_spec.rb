require 'spec_helper'

RSpec.describe Web::ActorPresenter do
  subject { described_class.new(actor) }

  describe '#photo' do
    context 'when present' do
      let(:actor) { Actor.new(photo_data: { id: '123.jpg', storage: 'store', metadata: {} }, image_url: 'nah') }

      it 'is a Shrine object' do
        expect(subject.photo).to be_a(Shrine::UploadedFile)
      end
    end

    context 'when missing' do
      let(:actor) { Actor.new() }

      it 'is nil' do
        expect(subject.photo).to be_nil
      end
    end
  end

  describe '#image_url_with_fallback' do
    context 'when photo present' do
      let(:actor) { Actor.new(photo_data: { id: '123.jpg', storage: 'store', metadata: {} }, image_url: 'nah') }

      it 'returns photo' do
        expect(subject.image_url_with_fallback).to eq '/uploads/123.jpg'
      end
    end

    context 'when photo missing' do
      let(:actor) { Actor.new(image_url: 'nah') }

      it 'returns image_url' do
        expect(subject.image_url_with_fallback).to eq 'nah'
      end
    end

    # TODO: This spec is not great - movie placeholder to constant
    context 'when both photo and image_url missing' do
      let(:actor) { Actor.new }

      it 'returns placeholder' do
        expect(subject.image_url_with_fallback).to eq 'https://via.placeholder.com/150'
      end
    end
  end

  describe '#imdb_url' do
    let(:actor) { Actor.new(tt_id: 'asdf') }

    it 'returns url' do
      expect(subject.imdb_url).to eq 'https://imdb.com/name/asdf'
    end
  end
end
