require 'spec_helper'

RSpec.describe Web::ActorPresenter do
  subject { described_class.new(actor) }

  describe '#photo' do
    context 'when present' do
      let(:actor) { Actor.new(photo_data: { id: '123.jpg', storage: 'store', metadata: {} }) }

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
end
